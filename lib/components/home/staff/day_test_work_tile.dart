import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../pages/test_page/test_creator.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'work_tile_placeholder.dart';

class DayTestWorkTile extends ConsumerWidget {
  const DayTestWorkTile(
      {super.key,
      required this.dayIndex,
      required this.batchData,
      required this.day});

  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget toGo = TestCreater(
      batchData: batchData,
      day: day,
      dayIndex: dayIndex,
      testType: TestType.daily,
    );

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    int cmpDate = DateTime.now().compareTo(
        DateFormat("dd-MM-yyyy").parse(day).add(const Duration(hours: 24)));

    bool datePassed = cmpDate == 1;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("dailyTest")
          .doc(batchData["name"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshot.data!.data()!.isNotEmpty &&
            snapshot.data!.data()!.containsKey(dayIndex.toString())) {
          Map<String, dynamic> testData =
              Map.from(snapshot.data!.data()![dayIndex.toString()]);

          Map<String, dynamic>? answerData = testData["answers"];

          bool isAllAttended = answerData != null
              ? answerData.length == List.from(batchData["students"]).length
              : false;

          bool notDone = datePassed && testData.isEmpty;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CustomText(
                    text: "DAILY TEST:",
                    color: colorData.fontColor(.5),
                    weight: FontWeight.w800,
                    size: sizeData.small,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  CustomText(
                    text: isAllAttended ? "All ATTENDED" : "ASSIGNED",
                    color: isAllAttended ? Colors.green : Colors.orange,
                    weight: FontWeight.w800,
                    size: sizeData.regular,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.008,
              ),
              GestureDetector(
                onTap: answerData != null && answerData.isNotEmpty
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => toGo,
                          ),
                        )
                    : () {},
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
                  child: notDone
                      ? Center(
                          child: CustomText(
                            text: "Test has not been initiated. (REPORTED)",
                            color: colorData.fontColor(.4),
                          ),
                        )
                      : answerData != null && answerData.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
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
                                      text: "absentStudents[currentIndex]",
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
                                text: "Test is created but no one attended!",
                                color: colorData.fontColor(.4),
                              ),
                            ),
                ),
              )
            ],
          );
        } else {
          if (datePassed) {
            return Center(
              child: CustomText(
                text: "Test has not been initiated. (REPORTED)",
                color: colorData.fontColor(.4),
              ),
            );
          } else {
            return WorkTilePlaceHolder(
              header: "day test",
              toGO: toGo,
              value: "Not created",
              placeholder: "Tap to create a day test",
            );
          }
        }
      },
    );
  }
}
