import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/page_header.dart';
import '../../components/common/text.dart';

import '../../components/common/text_list.dart';
import '../../components/test/daily_test/final_result_tile.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class DailyTestResult extends ConsumerWidget {
  const DailyTestResult({
    super.key,
    required this.dayIndex,
    required this.batchData,
    required this.day,
  });
  final int dayIndex;
  final Map<String, dynamic> batchData;
  final String day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    // double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("dailyTest")
                  .doc(batchData["name"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map<String, dynamic> testData =
                    Map.from(snapshot.data!.data()![dayIndex.toString()]);

                Map<String, dynamic>? answerData = testData["answers"];

                // bool isAllAttended = answerData != null
                //     ? answerData.length ==
                //         List.from(batchData["students"]).length
                //     : false;

                List<String> attendedStudents =
                    answerData != null ? answerData.keys.toList() : [];

                List<String> notAttendedStudents =
                    List.from(batchData["students"])
                        .map((e) =>
                            Map<String, dynamic>.from(e).keys.first.toString())
                        .toList();
                notAttendedStudents.removeWhere(
                    (element) => attendedStudents.contains(element));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      tittle: "DAILY TEST RESULT",
                      isMenuButton: false,
                      secondaryWidget: CustomText(
                        text: day,
                        size: sizeData.medium,
                        color: colorData.fontColor(.6),
                        weight: FontWeight.w800,
                        height: 2.25,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomText(
                      text: "NOT ATTENDED STUDENTS:",
                      color: colorData.fontColor(.5),
                      weight: FontWeight.w800,
                    ),
                    SizedBox(height: height * 0.01),
                    CustomListText(
                        data: notAttendedStudents,
                        placeholder: "All Attended the test successfully!",
                        getChild: (index) => notAttendedStudents[index]),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomText(
                      text: "ATTENDED STUDENTS:",
                      color: colorData.fontColor(.5),
                      weight: FontWeight.w800,
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: attendedStudents.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> instanceAnswerData =
                              Map<String, dynamic>.from(
                                  answerData![attendedStudents[index]]);
                          return FinalResultTile(
                            index: index,
                            name: instanceAnswerData["name"],
                            imageURL: instanceAnswerData["photo"],
                            points: instanceAnswerData["totalMark"].toString(),
                            startTime:
                                DateTime.parse(instanceAnswerData["startTime"]),
                            endTime:
                                DateTime.parse(instanceAnswerData["endTime"]),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
