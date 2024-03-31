import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/certificate.dart';
import '../../../pages/test_page/daily_test_attender.dart';
import '../../../pages/test_page/live_test_result.dart';
import '../../../pages/test_page/live_test_waiting_page.dart';
import '../../../providers/certificate_data_provider.dart';
import '../../../providers/user_detail_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = ref.watch(userDataProvider)!;
    CertificateData certificateData = ref.watch(certificateDataProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    void joinOrRemove(bool toadd) async {
      await FirebaseFirestore.instance
          .collection("liveTest")
          .doc(widget.batchData["name"])
          .set({
        firstIndex.toString(): {
          "students": (
            toadd
                ? {
                    userData["id"][widget.batchData["name"]]: {
                      "name": userData["name"],
                      "photo": userData["photo"] ?? userData["name"][0]
                    }
                  }
                : {
                    userData["id"][widget.batchData["name"]]:
                        FieldValue.delete(),
                  },
          ),
        }
      }, SetOptions(merge: true));
    }

    if (!certificateData.isEmpty() &&
        certificateData.courseDataList.isNotEmpty) {
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
        DateFormat('dd-MM-yyyy').parse(
          widget.batchData["dates"][firstIndex],
        ),
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
                  bool toShow = index < certificateData.courseDataList.length;
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
                          ? Row(
                              children: [
                                CustomText(
                                  text: dailyTestResult
                                      ? "Daily test result: "
                                      : "Todays test",
                                  size: sizeData.regular,
                                  color: colorData.fontColor(.6),
                                  weight: FontWeight.w800,
                                ),
                                SizedBox(
                                  width: !dailyTestResult ? width * 0.01 : null,
                                ),
                                !dailyTestResult
                                    ? CustomText(
                                        text: remainingTime(),
                                        size: sizeData.verySmall,
                                        color: colorData.fontColor(.6),
                                        weight: FontWeight.w800,
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (dailyTestResult) {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DailyTestAttender(
                                                    batchName: widget
                                                        .batchData["name"],
                                                    dayIndex:
                                                        firstIndex.toString(),
                                                    documentRef:
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "dailyTest")
                                                            .doc(widget
                                                                    .batchData[
                                                                "name"]),
                                                    userID: userData["id"][
                                                        widget.batchData[
                                                            "name"]]),
                                          ),
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
                                        text: dailyTestResult
                                            ? "VIEW RESULT"
                                            : "TAKE TEST",
                                        size: sizeData.regular,
                                        color: colorData.sideBarTextColor(1),
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                        dayIndex: firstIndex,
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
                                text: certificateData
                                    .courseDataList[firstIndex].title,
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
                                  text: certificateData
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
                            certificateData.courseDataList[firstIndex].files,
                      ),
                    ],
                  ),
                  liveTestInitiated
                      ? GestureDetector(
                          onTap: () {
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
      return CourseContentWaitingWidget(
          count: certificateData.courseDataLength);
    }
  }
}
