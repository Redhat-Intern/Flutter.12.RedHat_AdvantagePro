import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:redhat_v1/pages/test_page/live_test_result.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../../../pages/test_page/live_test_waiting_page.dart';
import '../../../providers/user_detail_provider.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
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

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("certificates")
          .doc(userData["currentBatch"].values.first)
          .collection("instances")
          .doc(userData["currentBatch"].keys.first)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data()!.isNotEmpty) {
          Map<String, dynamic> documentData = snapshot.data!.data()!;
          Map<String, dynamic> courseContent = documentData["courseContent"];

          String? liveTest;
          if (widget.batchData["liveTest"] != null) {
            liveTest = widget.batchData["liveTest"][firstIndex.toString()];
          }
          bool liveTestResult = liveTest != null && liveTest == "completed";
          bool liveTestInitiated = liveTest != null && liveTest == "created";

          String? dayTest;
          if (widget.batchData["dayTest"] != null) {
            dayTest = widget.batchData["dayTest"][firstIndex.toString()];
          }
          int dateCmp = DateTime.now().compareTo(DateFormat('dd-MM-yyyy')
              .parse(widget.batchData["dates"][firstIndex]));
          bool dayTestResult = dayTest != null && dateCmp == 1;

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
                    itemCount: courseContent.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          firstIndex = index;
                        }),
                        child: Container(
                          margin: EdgeInsets.only(right: width * 0.03),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: height * 0.005,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: colorData
                                .secondaryColor(firstIndex == index ? .4 : .3),
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
                          dayTest != null
                              ? Row(
                                  children: [
                                    CustomText(
                                      text: dayTestResult
                                          ? "Daily test result: "
                                          : "Todays test",
                                      size: sizeData.regular,
                                      color: colorData.fontColor(.6),
                                      weight: FontWeight.w800,
                                    ),
                                    SizedBox(
                                      width:
                                          !dayTestResult ? width * 0.01 : null,
                                    ),
                                    !dayTestResult
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
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.025,
                                            vertical: height * 0.01),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                            colors: [
                                              colorData.primaryColor(.4),
                                              colorData.primaryColor(.7)
                                            ],
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: dayTestResult
                                              ? "VIEW RESULT"
                                              : "TAKE TEST",
                                          size: sizeData.regular,
                                          color: colorData.sideBarTextColor(1),
                                          weight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: dayTest != null ? height * 0.01 : null,
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
                                            day: List.from(
                                                    widget.batchData["dates"])[
                                                firstIndex]),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                    text: courseContent[firstIndex.toString()]
                                        ["title"],
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
                                      text: courseContent[firstIndex.toString()]
                                          ["topics"],
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
                            courseFiles: courseContent[firstIndex.toString()]
                                ["files"],
                            from: CourseFileListFrom.courseConent,
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
                                      day: widget.batchData["dates"]
                                          [firstIndex],
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
