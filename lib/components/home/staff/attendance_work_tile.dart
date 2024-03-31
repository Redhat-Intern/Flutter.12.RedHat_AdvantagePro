import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../common/text.dart';
import '../../../pages/attendence_page.dart';
import 'work_tile_placeholder.dart';

class AttendanceWorkTile extends ConsumerWidget {
  const AttendanceWorkTile(
      {super.key,
      required this.dayIndex,
      required this.batchData,
      required this.day});

  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget toGo = AttendencePage(
      docRef: FirebaseFirestore.instance
          .collection("attendence")
          .doc(batchData["name"]),
      students:
          List.from(batchData["students"]).map((e) => Map.from(e)).toList(),
      day: day,
      dayIndex: dayIndex,
    );

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("attendence")
          .doc(batchData["name"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshot.data!.data()!.isNotEmpty &&
            snapshot.data!.data()![dayIndex.toString()] != null) {
          Map<String, dynamic> attendenceList =
              snapshot.data!.data()![dayIndex.toString()];

          List<String> absentStudents = attendenceList.entries
              .where((element) => element.value == false)
              .map((e) => e.key.toString())
              .toList();
          int absentCount = absentStudents.length;
          int notSet = batchData["students"].length - attendenceList.length;
          bool completed = notSet == 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: "ATTENDENCE:",
                    color: colorData.fontColor(.5),
                    weight: FontWeight.w800,
                    size: sizeData.small,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  CustomText(
                    text: completed ? "COMPLETED" : "PENDING..",
                    color: completed ? Colors.green : Colors.orange,
                    weight: FontWeight.w800,
                    size: sizeData.regular,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.008,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => toGo,
                      ),
                    ),
                    child: Container(
                      width: width,
                      height: height * 0.0525,
                      padding: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                        top: height * 0.006,
                        bottom: height * 0.006,
                      ),
                      decoration: BoxDecoration(
                        color: colorData.backgroundColor(1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: absentCount > 0
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: absentStudents.length,
                              itemBuilder: (context, currentIndex) {
                                return Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                    vertical: height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: colorData.secondaryColor(.4),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      text: absentStudents[currentIndex],
                                      size: sizeData.regular,
                                      color: colorData.primaryColor(.6),
                                      weight: FontWeight.w800,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: CustomText(
                                text: notSet > 0
                                    ? "Need to update $notSet students attendence"
                                    : "All students are present! 🥳",
                                color: colorData.fontColor(.4),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: -height * 0.025,
                    right: -width * .02,
                    child: absentCount > 0
                        ? Container(
                            padding: EdgeInsets.all(aspectRatio * 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.red.shade200, Colors.red],
                              ),
                            ),
                            child: CustomText(
                              text: (absentCount + notSet).toString(),
                              color: colorData.sideBarTextColor(1),
                              weight: FontWeight.w700,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              )
            ],
          );
        } else {
          return WorkTilePlaceHolder(
              header: "attendence",
              toGO: toGo,
              value: "not created",
              placeholder: "Tap to edit the student's attendence");
        }
      },
    );
  }
}
