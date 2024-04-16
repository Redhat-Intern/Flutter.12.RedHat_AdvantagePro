import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/pages/test_page/live_test_result.dart';
import 'package:redhat_v1/providers/livetest_provider.dart';

import '../../components/common/text.dart';
import '../../components/test/live_test/custom_progress_bar.dart';
import '../../components/test/live_test/hold_page.dart';
import '../../components/test/live_test/options_selector.dart';
import '../../components/test/live_test/ranking_board.dart';
import '../../model/test.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestAttender extends ConsumerStatefulWidget {
  const LiveTestAttender({
    super.key,
    required this.testData,
    required this.documentRef,
    required this.dayIndex,
    required this.userID,
    required this.batchName,
  });
  final Map<String, dynamic> testData;
  final DocumentReference<Map<String, dynamic>> documentRef;
  final String dayIndex;
  final String userID;
  final String batchName;

  @override
  ConsumerState<LiveTestAttender> createState() => _LiveTestAttenderState();
}

class _LiveTestAttenderState extends ConsumerState<LiveTestAttender> {
  late List<TestField> testFields;
  late TestField currentTestField;

  DateTime onInitializeTime = DateTime.now();

  bool toShowResult = false;
  bool waitingRoom = false;
  int seconds = 0;
  int totalScore = 0;

  int scoreCalculator(double time, bool answerCheck) {
    double howFast = seconds - time;
    if (answerCheck) {
      setState(() {
        totalScore += (howFast * 100).toInt();
      });
      return (howFast * 100).toInt();
    }
    return 0;
  }

  double getTimeDifference(DateTime time1, DateTime time2) {
    int differenceInMilliseconds = time2.difference(time1).inMilliseconds;

    double differenceInSeconds =
        differenceInMilliseconds / Duration.millisecondsPerSecond;
    return double.parse(differenceInSeconds.toStringAsFixed(4));
  }

  setOption(MapEntry<String, String>? option) {
    setState(() {
      waitingRoom = true;
      double time = getTimeDifference(onInitializeTime, DateTime.now());
      bool checkAnswer = currentTestField.answer == option?.key;

      widget.documentRef.set({
        widget.dayIndex: {
          "answers": {
            currentTestField.question: {
              widget.userID: {
                "time": time,
                "option": option?.key,
                "score": scoreCalculator(time, checkAnswer)
              },
            }
          },
          "totalScores": {
            widget.userID: totalScore,
          }
        }
      }, SetOptions(merge: true));
    });
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
        waitingRoom = false;
      });

      await Future.delayed(const Duration(seconds: 5));
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    int questionIndex = testFields.indexOf(currentTestField);

    double height = sizeData.height;
    double width = sizeData.width;

    Map<String, dynamic>? testData = ref.watch(liveTestProvider);
    int totalSC = testData != null && testData["totalScore"] != null
        ? testData["totalScore"][widget.userID]
        : 0;

    Widget pageWidget = waitingRoom
        ? const HoldPage()
        : questionIndex == testFields.length - 1 && toShowResult
            ? LiveTestResult(
                dayIndex: widget.dayIndex, batchName: widget.batchName)
            : toShowResult
                ? RankingBoard(currentTestField: currentTestField)
                : Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomProgressBar(
                          seconds: seconds, testData: currentTestField),
                      SizedBox(
                        height: height * 0.03,
                      ),
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
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.0025),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: colorData.secondaryColor(.8),
                            ),
                            child: Row(children: [
                              CustomText(
                                text: emojis['0']!,
                                color: Colors.white,
                                weight: FontWeight.bold,
                                size: sizeData.header,
                              ),
                              CustomText(
                                text: totalSC.toString(),
                                weight: FontWeight.w800,
                                color: colorData.fontColor(.9),
                                size: sizeData.medium,
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                            ]),
                          )
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
                      OptionsSelector(
                        currentTestField: currentTestField,
                        setOption: setOption,
                      )
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
