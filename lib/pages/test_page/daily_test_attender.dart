import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';
import 'package:redhat_v1/providers/livetest_provider.dart';

import '../../components/common/text.dart';
import '../../components/test/daily_test/progress_bar.dart';
import '../../components/test/live_test/custom_progress_bar.dart';
import '../../components/test/live_test/hold_page.dart';
import '../../components/test/live_test/options_selector.dart';
import '../../components/test/live_test/ranking_board.dart';
import '../../model/test.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class DailyTestAttender extends ConsumerStatefulWidget {
  const DailyTestAttender({
    super.key,
    required this.documentRef,
    required this.dayIndex,
    required this.userID,
    required this.batchName,
  });
  final DocumentReference<Map<String, dynamic>> documentRef;
  final String dayIndex;
  final String userID;
  final String batchName;

  @override
  ConsumerState<DailyTestAttender> createState() => _DailyTestAttenderState();
}

class _DailyTestAttenderState extends ConsumerState<DailyTestAttender> {
  List<TestField> testFields = [];
  int testIndex = 0;
  List<String?> answers = [];
  int totalMark = 0;
  int count = 0;
  bool canPop = false;

  late DateTime onInitializeTime;

  int duration = 0;

  setOption(MapEntry<String, String> option) {
    setState(() {
      if (answers[testIndex] == null) count++;
      answers[testIndex] = option.key;
      totalMark += testFields[testIndex].answer == option.key ? 100 : 0;
    });
  }

  submitTest() {
    if (testFields.length == count) {
      widget.documentRef.set({
        widget.dayIndex: {
          "answers": {
            widget.userID: {
              "answer": answers,
              "totalMark": totalMark,
              "startTime": onInitializeTime.toIso8601String(),
              "endTime": DateTime.now().toIso8601String(),
            },
          }
        }
      }, SetOptions(merge: true));
      setState(() {
        canPop = true;
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Center(child: Text("Not yet answered to all the questions"))));
    }
  }

  toBack() {
    setState(() {
      if (testIndex > 0) testIndex--;
    });
  }

  toNext() {
    setState(() {
      if (testIndex < testFields.length - 1) testIndex++;
    });
  }

  setIndex(int index) {
    setState(() {
      testIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.documentRef
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
      Map<String, dynamic> data = value.data()![widget.dayIndex];
      List<TestField> testDataList = List.from(data["data"]).map((e) {
        Map testData = Map.from(e);
        Map<String, String> options =
            Map<String, String>.from(testData["options"]);

        return TestField(
          testData["question"],
          options,
          testData["answer"],
        );
      }).toList();
      setState(() {
        duration = int.parse(data["duration"]);
        testFields = testDataList;
        answers = List.generate(testDataList.length, (index) => null);
        onInitializeTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    Widget pageWidget = testFields.isEmpty
        ? const HoldPage(fromDaily: "Testing System is on preparation")
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              DailyTestProgressBar(minutes: duration, submitTest: submitTest),
              SizedBox(height: height * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: "Question ${testIndex + 1}",
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
                margin:
                    EdgeInsets.only(bottom: height * 0.02, top: height * 0.02),
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
                text: testFields[testIndex].question,
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
                answer: answers[testIndex],
                currentTestField: testFields[testIndex],
                setOption: setOption,
              ),
              IndexShifters(
                  submitTest: submitTest,
                  testIndex: testIndex,
                  testFields: testFields,
                  toBack: toBack,
                  toNext: toNext),
              SizedBox(height: height * 0.05),
              QuestionPreviewList(
                  answerList: answers,
                  testFields: testFields,
                  testIndex: testIndex,
                  setIndex: setIndex),
              SizedBox(height: height * 0.03),
            ],
          );

    return PopScope(
      canPop: canPop,
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

class IndexShifters extends ConsumerWidget {
  const IndexShifters({
    super.key,
    required this.testIndex,
    required this.testFields,
    required this.toBack,
    required this.toNext,
    required this.submitTest,
  });

  final int testIndex;
  final List<TestField> testFields;
  final Function toBack;
  final Function toNext;
  final Function submitTest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    bool isLast = testIndex == testFields.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => toBack(),
          child: Opacity(
            opacity: testIndex == 0 ? .5 : 1,
            child: Container(
              padding: EdgeInsets.only(
                right: width * 0.04,
                left: width * 0.02,
                top: height * 0.01,
                bottom: height * 0.01,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorData.secondaryColor(.5),
              ),
              child: Row(
                children: [
                  CustomIcon(
                      size: sizeData.aspectRatio * 50,
                      icon: Icons.arrow_back_ios_rounded,
                      color: colorData.fontColor(.6)),
                  SizedBox(width: width * 0.02),
                  CustomText(
                      text: "BACK",
                      size: sizeData.medium,
                      weight: FontWeight.w800),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => isLast ? submitTest() : toNext(),
          child: Container(
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * (isLast ? .04 : 0.02),
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.primaryColor(.8),
            ),
            child: Row(
              children: [
                CustomText(
                  text: isLast ? "SUBMIT" : "NEXT",
                  size: sizeData.medium,
                  weight: FontWeight.w800,
                  color: colorData.sideBarTextColor(1),
                ),
                SizedBox(width: isLast ? 0 : width * 0.02),
                isLast
                    ? const SizedBox()
                    : CustomIcon(
                        size: sizeData.aspectRatio * 50,
                        icon: Icons.arrow_forward_ios_rounded,
                        color: colorData.sideBarTextColor(1),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuestionPreviewList extends ConsumerStatefulWidget {
  const QuestionPreviewList({
    super.key,
    required this.testFields,
    required this.testIndex,
    required this.setIndex,
    required this.answerList,
  });

  final List<TestField> testFields;
  final int testIndex;
  final Function setIndex;
  final List<String?> answerList;

  @override
  ConsumerState<QuestionPreviewList> createState() =>
      _QuestionPreviewListState();
}

class _QuestionPreviewListState extends ConsumerState<QuestionPreviewList> {
  final ScrollController _controller = ScrollController();

  @override
  void didUpdateWidget(QuestionPreviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testIndex != widget.testIndex) {
      double itemWidth = MediaQuery.of(context).size.width * 0.25;
      double scrollOffset = itemWidth * widget.testIndex;
      setState(() {
        _controller.animateTo(
          scrollOffset,
          curve: Curves.ease,
          duration: Durations.medium4,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SizedBox(
      height: height * 0.05,
      child: ListView.builder(
        controller: _controller,
        padding: EdgeInsets.symmetric(vertical: height * 0.002),
        scrollDirection: Axis.horizontal,
        itemCount: widget.testFields.length,
        itemBuilder: (context, index) {
          bool isSelected = index == widget.testIndex;
          return GestureDetector(
            onTap: () => widget.setIndex(index),
            child: AnimatedContainer(
              duration: Durations.medium4,
              margin: EdgeInsets.only(right: width * 0.03),
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? colorData.primaryColor(.8)
                    : widget.answerList[index] != null
                        ? Colors.green
                        : colorData.secondaryColor(.5),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: widget.testFields[index].question.substring(0, 10),
                size: sizeData.regular,
                weight: FontWeight.w800,
                color: isSelected || widget.answerList[index] != null
                    ? colorData.sideBarTextColor(1)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
