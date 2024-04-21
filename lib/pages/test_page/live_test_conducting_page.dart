import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/pages/test_page/live_test_result.dart';

import '../../components/common/text.dart';
import '../../components/test/live_test/ranking_board.dart';
import '../../model/test.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestConductPage extends ConsumerStatefulWidget {
  const LiveTestConductPage({
    super.key,
    required this.testData,
    required this.dayIndex,
    required this.batchName,
  });

  final Map<String, dynamic> testData;
  final String dayIndex;
  final String batchName;

  @override
  ConsumerState<LiveTestConductPage> createState() =>
      _LiveTestConductPageState();
}

class _LiveTestConductPageState extends ConsumerState<LiveTestConductPage> {
  late List<TestField> testFields;
  late TestField currentTestField;

  DateTime onInitializeTime = DateTime.now();

  bool toShowResult = false;
  int seconds = 0;

  double getTimeDifference(DateTime time1, DateTime time2) {
    int differenceInMilliseconds = time2.difference(time1).inMilliseconds;

    double differenceInSeconds =
        differenceInMilliseconds / Duration.millisecondsPerSecond;
    return double.parse(differenceInSeconds.toStringAsFixed(4));
  }

  Future<void> mainTestCreator(List<TestField> testFields) async {
    for (int count = 0; count < testFields.length; count++) {
      if (!mounted) break;

      setState(() {
        currentTestField = testFields[count];
        seconds = int.parse(widget.testData["duration"].toString());
        onInitializeTime = DateTime.now();
        toShowResult = false;
      });

      await Future.delayed(Duration(seconds: seconds));

      setState(() {
        toShowResult = true;
      });

      await Future.delayed(const Duration(seconds: 5));

      if (count == testFields.length - 1) {
        FirebaseFirestore.instance
            .collection("batches")
            .doc(widget.batchName)
            .set({
          "liveTest": {
            widget.dayIndex: "completed",
          }
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    testFields = List.from(widget.testData["data"]).map((e) {
      return TestField(
        e["question"],
        Map.from(e["options"])
            .map((key, value) => MapEntry(key, value.toString())),
        e["answer"],
      );
    }).toList();

    mainTestCreator(testFields);
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    int questionIndex = testFields.indexOf(currentTestField);

    double height = sizeData.height;
    double width = sizeData.width;

    Widget pageWidget = questionIndex == testFields.length - 1 && toShowResult
        ? LiveTestResult(
            dayIndex: widget.dayIndex,
            batchName: widget.batchName,
            popMethod: () {
              FirebaseFirestore.instance
                  .collection("batches")
                  .doc(widget.batchName)
                  .set({
                "liveTest": {widget.dayIndex: "completed"}
              }, SetOptions(merge: true));
              Navigator.pop(context);
            },
          )
        : toShowResult
            ? RankingBoard(currentTestField: currentTestField)
            : Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: "LIVE TEST",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                    height: 2,
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text:
                            "Question ${testFields.indexOf(currentTestField) + 1}",
                        size: sizeData.header,
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.8),
                      ),
                      CustomText(
                        text: "/${testFields.length}",
                        color: colorData.fontColor(.5),
                        weight: FontWeight.w800,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.02, top: height * 0.02),
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colorData.fontColor(.1),
                      gradient: LinearGradient(
                        colors: List.generate(
                          30,
                          (index) => index % 2 == 0
                              ? colorData.fontColor(1)
                              : colorData.secondaryColor(1),
                        ).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: currentTestField.question,
                    maxLine: 5,
                    size: sizeData.header,
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.9),
                    height: 1.25,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("liveTest")
                          .doc(widget.batchName)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData &&
                            snapshot.data!.exists &&
                            snapshot.data!.data()![widget.dayIndex]
                                    ["answers"] !=
                                null) {
                          Map<String, dynamic> answerData =
                              Map<String, dynamic>.from(snapshot.data!
                                  .data()![widget.dayIndex]["answers"]);

                          Map<String, dynamic> studentsData =
                              Map<String, dynamic>.from(snapshot.data!
                                  .data()![widget.dayIndex]["students"]);

                          Map<String, dynamic>? currentAnswerMap =
                              answerData[currentTestField.question] != null
                                  ? Map<String, dynamic>.from(
                                      answerData[currentTestField.question])
                                  : null;
                          if (currentAnswerMap != null) {
                            List<MapEntry<String, dynamic>> currentAnsList =
                                currentAnswerMap.entries.toList();
                            // currentAnsList.sort((a,b){
                            //   a.value
                            // });
                            return ListView.builder(
                                itemCount: currentAnsList.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> studentData =
                                      Map<String, dynamic>.from(studentsData[
                                          currentAnsList[index].key]);
                                  return ResultTile(
                                    time: double.parse(currentAnsList[index]
                                        .value["time"]
                                        .toString()),
                                    name: studentData["name"],
                                    imageURL: studentData["photo"],
                                    option:
                                        currentAnsList[index].value["option"],
                                    points: currentAnsList[index]
                                        .value["score"]
                                        .toString(),
                                  );
                                });
                          } else {
                            return const Center(
                              child: CustomText(
                                  text: "No Students had answered yet!"),
                            );
                          }
                        } else {
                          return const Center(
                            child: CustomText(
                                text: "No Students had answered yet!"),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: SafeArea(
          child: AnimatedContainer(
            duration: Durations.short1,
            margin: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
              top: height * 0.02,
            ),
            child: pageWidget,
          ),
        ),
      ),
    );
  }
}

class ResultTile extends ConsumerWidget {
  const ResultTile({
    super.key,
    required this.name,
    required this.imageURL,
    required this.option,
    required this.points,
    required this.time,
  });

  final String name;
  final String imageURL;
  final String points;
  final String option;
  final double time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.025,
      ),
      child: Row(
        children: [
          CustomText(
            text: time.toStringAsFixed(2),
            size: sizeData.small,
            color: colorData.primaryColor(.8),
          ),
          SizedBox(width: width * 0.02),
          Container(
            height: aspectRatio * 95,
            width: aspectRatio * 95,
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.03),
            padding: EdgeInsets.all(aspectRatio * 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorData.secondaryColor(1),
              border: Border.all(color: colorData.primaryColor(.3), width: 2),
            ),
            alignment: Alignment.center,
            child: imageURL.length == 1
                ? CustomText(
                    text: imageURL,
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w800,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(imageURL),
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                size: sizeData.subHeader,
                weight: FontWeight.w700,
              ),
              SizedBox(height: height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: "OPTION:",
                    size: sizeData.small,
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                  ),
                  SizedBox(width: width * 0.01),
                  CustomText(
                    text: option,
                    size: sizeData.medium,
                    weight: FontWeight.w800,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.005, horizontal: width * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  colorData.secondaryColor(.4),
                  colorData.secondaryColor(.9),
                ],
              ),
            ),
            child: CustomText(
              text: "$points pt",
              size: sizeData.medium,
              color: colorData.primaryColor(.8),
              weight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
