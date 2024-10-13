import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../components/test/daily_test/index_shifter.dart';
import '../../components/test/daily_test/progress_bar.dart';
import '../../components/test/daily_test/question_privewlist.dart';
import '../../components/test/live_test/hold_page.dart';
import '../../components/test/live_test/options_selector.dart';
import '../../model/test.dart';
import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
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

class _DailyTestAttenderState extends ConsumerState<DailyTestAttender>
    with WidgetsBindingObserver {
  int stateCount = 0;
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

  submitTest(UserModel userData) {
    if (testFields.length == count) {
      widget.documentRef.set({
        widget.dayIndex: {
          "answers": {
            widget.userID: {
              "answer": answers,
              "totalMark": totalMark,
              "startTime": onInitializeTime.toIso8601String(),
              "endTime": DateTime.now().toIso8601String(),
              "name": userData.name,
              "photo": userData.imagePath,
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
    WidgetsBinding.instance.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed) {
      stateCount += 1;
      debugPrint('App is in the foreground');
      if (stateCount > 1) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: CustomText(
                text: "The test was closed due to application navigation.",
                maxLine: 2,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: CustomText(
                text:
                    "Test page will terminate if you navigate away from the app again",
                maxLine: 2,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider).key;
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
              DailyTestProgressBar(
                  minutes: duration, submitTest: () => submitTest(userData)),
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
                size: sizeData.subHeader,
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
                  submitTest: () => submitTest(userData),
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
