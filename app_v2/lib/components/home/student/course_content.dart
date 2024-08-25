
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/course.dart';
import '../../../model/user.dart';
import '../../../pages/test_page/daily_test_attender.dart';
import '../../../pages/test_page/live_test_result.dart';
import '../../../pages/test_page/live_test_waiting_page.dart';
import '../../../providers/course_data_provider.dart';
import '../../../providers/user_detail_provider.dart';
import '../../../utilities/console_logger.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/shimmer_box.dart';
import '../../common/text.dart';
import '../../common/waiting_widgets/course_waiting.dart';
import 'course_files.dart';

class CourseContent extends ConsumerStatefulWidget {
  const CourseContent({
    super.key,
    required this.batchData,
  });
  final Map<String, dynamic> batchData;

  @override
  ConsumerState<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends ConsumerState<CourseContent> {
  // Telephony telephony = Telephony.instance;
  // bool isInCall = false;

  int firstIndex = 0;

  String remainingTime() {
    Duration remainingTime = calculateRemainingTime();

    String displayTime;
    if (remainingTime.inHours >= 1) {
      int hours = remainingTime.inHours;
      displayTime = '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      int minutes = remainingTime.inMinutes;
      displayTime = '$minutes minute${minutes > 1 ? 's' : ''}';
    }

    return '(end with in $displayTime) :';
  }

  Duration calculateRemainingTime() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    Duration remainingTime = endOfDay.difference(now);
    return remainingTime;
  }

  // Future<void> listenToCall() async {
  //   CallState callState = await telephony.callState;
  //   setState(() {
  //     if (callState == CallState.RINGING || callState == CallState.OFFHOOK) {
  //       isInCall = true;
  //     } else {
  //       isInCall = false;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider);
    CourseData courseData = ref.watch(courseDataProvider);

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    void joinOrRemove(bool toadd) async {

      Map<String, dynamic> data = toadd
          ? {
              userData.studentId![widget.batchData["name"]]!: {
                "name": userData.name,
                "photo": userData.imagePath
              }
            }
          : {
              userData.studentId![widget.batchData["name"]]!:
                  FieldValue.delete(),
            };
      try {
        await FirebaseFirestore.instance
            .collection("liveTest")
            .doc(widget.batchData["name"])
            .set({
          firstIndex.toString(): {
            "students": data,
          }
        }, SetOptions(merge: true));
      } catch (error) {
        ConsoleLogger.message(error);
      }
    }

    if (!courseData.isEmpty() && courseData.courseDataList.isNotEmpty) {
      List<String> batchDates = List.from(widget.batchData["dates"]);
      String? liveTest;
      if (widget.batchData["liveTest"] != null) {
        liveTest = widget.batchData["liveTest"][firstIndex.toString()];
      }
      bool liveTestResult = liveTest != null && liveTest == "completed";
      bool liveTestInitiated = liveTest != null && liveTest == "created";

      bool? dailyTest;
      if (widget.batchData["dailyTest"] != null) {
        dailyTest = widget.batchData["dailyTest"][firstIndex.toString()];
      }
      int dateCmp = DateTime.now().compareTo(
        DateFormat('dd-MM-yyyy')
            .parse(
              widget.batchData["dates"][firstIndex],
            )
            .add(const Duration(hours: 24)),
      );
      bool dailyTestResult = dailyTest != null && dateCmp == 1;

      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Course content",
              size: sizeData.subHeader,
              color: colorData.fontColor(.8),
              weight: FontWeight.w800,
            ),
            SizedBox(
              height: height * .01,
            ),
            Container(
              width: width,
              height: height * 0.06,
              padding: EdgeInsets.only(
                left: width * 0.03,
                right: width * 0.03,
                top: height * 0.006,
                bottom: height * 0.006,
              ),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.005,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: batchDates.length,
                itemBuilder: (context, index) {
                  bool toShow = index < courseData.courseDataList.length;
                  return GestureDetector(
                    onTap: toShow
                        ? () => setState(() {
                              firstIndex = index;
                            })
                        : () {},
                    child: toShow
                        ? Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.005,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: colorData.secondaryColor(
                                  firstIndex == index ? .4 : .3),
                            ),
                            child: Center(
                              child: CustomText(
                                text: "Day $index",
                                size: sizeData.regular,
                                color: firstIndex == index
                                    ? colorData.primaryColor(.8)
                                    : colorData.fontColor(.4),
                                weight: FontWeight.w800,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: width * 0.03),
                            child: ShimmerBox(
                                height: sizeData.superHeader,
                                width: width * .15),
                          ),
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              height: height * .45,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.01,
              ),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      dailyTest != null
                          ? DailyTestTile(
                              userId: userData
                                  .studentId![widget.batchData["name"]]!,
                              dayIndex: firstIndex.toString(),
                              batchName: widget.batchData["name"],
                              timeEnd: dailyTestResult,
                              remainingTime: remainingTime(),
                              toGo: DailyTestAttender(
                                batchName: widget.batchData["name"],
                                dayIndex: firstIndex.toString(),
                                documentRef: FirebaseFirestore.instance
                                    .collection("dailyTest")
                                    .doc(widget.batchData["name"]),
                                userID: userData
                                    .studentId![widget.batchData["name"]]!,
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: dailyTest != null ? height * 0.01 : null,
                      ),
                      liveTestResult
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LiveTestResult(
                                        dayIndex: firstIndex.toString(),
                                        batchName: widget.batchData["name"],
                                        day: List.from(widget
                                            .batchData["dates"])[firstIndex]),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  CustomText(
                                    text: "LIVE TEST result:",
                                    size: sizeData.regular,
                                    color: colorData.fontColor(.6),
                                    weight: FontWeight.w800,
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.015,
                                          vertical: height * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            colorData.secondaryColor(.2),
                                            colorData.secondaryColor(.4)
                                          ],
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: "VIEW RESULT",
                                        size: sizeData.regular,
                                        color: colorData.fontColor(.8),
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: liveTestResult ? height * 0.01 : null,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Title:",
                            size: sizeData.regular,
                            color: colorData.fontColor(.6),
                            weight: FontWeight.w800,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.008),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    colorData.secondaryColor(.2),
                                    colorData.secondaryColor(.4)
                                  ],
                                ),
                              ),
                              child: CustomText(
                                text:
                                    courseData.courseDataList[firstIndex].title,
                                size: sizeData.regular,
                                color: colorData.fontColor(.8),
                                weight: FontWeight.w800,
                                maxLine: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Topics:",
                            size: sizeData.regular,
                            color: colorData.fontColor(.6),
                            weight: FontWeight.w800,
                            height: 2,
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.008),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    colorData.secondaryColor(.2),
                                    colorData.secondaryColor(.4)
                                  ],
                                ),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: CustomText(
                                  text: courseData
                                      .courseDataList[firstIndex].topics,
                                  size: sizeData.regular,
                                  color: colorData.fontColor(.8),
                                  weight: FontWeight.w800,
                                  maxLine: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                      SizedBox(
                        height: height * 0.01,
                      ),
                      CourseFiles(
                        courseFiles:
                            courseData.courseDataList[firstIndex].files,
                      ),
                    ],
                  ),
                  liveTestInitiated
                      ? GestureDetector(
                          onTap: () {
                            // await listenToCall();
                            // if (isInCall) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Center(
                            //       child: CustomText(
                            //         text:
                            //             "Cannot take the test when attending the call!",
                            //         maxLine: 2,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // );
                            // } else {
                            joinOrRemove(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveTestWaitingRoom(
                                  dayIndex: firstIndex,
                                  batchData: widget.batchData,
                                  day: widget.batchData["dates"][firstIndex],
                                  todo: joinOrRemove,
                                ),
                              ),
                            );
                            // }
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorData.secondaryColor(.8),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "Tap to enter the\nLIVE TEST",
                              maxLine: 2,
                              align: TextAlign.center,
                              size: sizeData.subHeader,
                              height: 1.5,
                              weight: FontWeight.bold,
                              color: colorData.primaryColor(1),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return CourseContentWaitingWidget(count: courseData.courseDataLength);
    }
  }
}

class DailyTestTile extends ConsumerWidget {
  const DailyTestTile(
      {super.key,
      required this.timeEnd,
      required this.batchName,
      required this.remainingTime,
      required this.toGo,
      required this.dayIndex,
      required this.userId});

  final bool timeEnd;
  final String batchName;
  final String remainingTime;
  final Widget toGo;
  final String dayIndex;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("dailyTest")
            .doc(batchName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            bool dailyTestResult = timeEnd;
            Map<String, dynamic> data = snapshot.data!.data()!;
            bool isAnswered = data[dayIndex]["answers"] != null &&
                data[dayIndex]["answers"][userId] != null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: dailyTestResult
                      ? "Daily test result: "
                      : isAnswered
                          ? "Daily test has been already attended"
                          : "Todays test",
                  size: sizeData.regular,
                  color: colorData.fontColor(.6),
                  weight: FontWeight.w800,
                ),
                SizedBox(
                  width: !dailyTestResult && !isAnswered ? width * 0.01 : null,
                ),
                !dailyTestResult && !isAnswered
                    ? CustomText(
                        text: remainingTime,
                        size: sizeData.verySmall,
                        color: colorData.fontColor(.6),
                        weight: FontWeight.w800,
                      )
                    : const SizedBox(),
                SizedBox(
                  width: width * 0.02,
                ),
                isAnswered
                    ? const SizedBox()
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (dailyTestResult) {
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => toGo),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.025,
                                vertical: height * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [
                                  colorData.primaryColor(.4),
                                  colorData.primaryColor(.7)
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text:
                                  dailyTestResult ? "VIEW RESULT" : "TAKE TEST",
                              size: sizeData.regular,
                              color: colorData.sideBarTextColor(1),
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(height: sizeData.header, width: width * .5),
                ShimmerBox(height: sizeData.superLarge, width: width * 0.3)
              ],
            );
          }
        });
  }
}
