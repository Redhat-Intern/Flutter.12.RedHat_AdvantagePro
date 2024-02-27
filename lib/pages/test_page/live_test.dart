import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';
import '../../components/test/add_test_page.dart';
import '../../model/test.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestCreater extends ConsumerStatefulWidget {
  const LiveTestCreater(
      {super.key,
      required this.batchData,
      required this.dayIndex,
      required this.day});
  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;

  @override
  ConsumerState<LiveTestCreater> createState() => _LiveTestCreaterState();
}

class _LiveTestCreaterState extends ConsumerState<LiveTestCreater> {
  TextEditingController timeCtr = TextEditingController();
  int? expandedIndex;
  List<TestField> testFields = [];

  void addTestField(TestField testField) {
    setState(() {
      testFields.add(testField);
    });
  }

  void onSubmit() {
    if (timeCtr.text != ""
        // && testFields.isNotEmpty
        ) {
      FirebaseFirestore.instance
          .collection("liveTest")
          .doc(widget.batchData["name"])
          .set({
        widget.dayIndex.toString(): {
          "duration": timeCtr.text.trim(),
          "data": sample_data
          // testFields.map((e) => e.toMap()).toList(),
        }
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: CustomText(
            text: "Live Test added successfully!",
            color: Colors.white,
          ),
        ),
      ));
      Navigator.pop(context);
    } else if (timeCtr.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: CustomText(
            text: "Please enter the duration of the test",
            color: Colors.white,
          ),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
          child: CustomText(
            text: "Please add some questions to create the test",
            color: Colors.white,
          ),
        ),
      ));
    }
  }

  @override
  void dispose() {
    timeCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(
                    flex: 2,
                  ),
                  CustomText(
                    text: "LIVE TEST",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                  ),
                  const Spacer(),
                  CustomText(
                    text: widget.day,
                    size: sizeData.medium,
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w800,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Test Duration ",
                        weight: FontWeight.w800,
                        color: colorData.fontColor(.8),
                        size: sizeData.medium,
                      ),
                      CustomText(
                        text: "(in seconds for each question):",
                        color: colorData.fontColor(.6),
                        size: sizeData.small,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: width * 0.02,
                        right: width * 0.02,
                      ),
                      height: height * 0.035,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: colorData.secondaryColor(.5),
                      ),
                      child: TextField(
                        controller: timeCtr,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          height: 1,
                          color: colorData.primaryColor(1),
                          fontWeight: FontWeight.bold,
                          fontSize: sizeData.regular,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(bottom: height * 0.02),
                          hintText: "seconds",
                          hintStyle: TextStyle(
                            color: colorData.fontColor(.6),
                            fontSize: sizeData.small,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddQuestionSet(addTestField: addTestField),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: colorData.secondaryColor(.5),
                    ),
                    child: const CustomText(
                      text: "ADD QUESTION",
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
             testFields.isNotEmpty? Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    scrollDirection: Axis.vertical,
                    itemCount: testFields.length,
                    itemBuilder: (context, index) {
                      bool toExpand = expandedIndex == index;
                      return AnimatedContainer(
                        duration: Durations.short4,
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.02,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorData.secondaryColor(.5),
                        ),
                        child: AnimatedSize(
                          duration: Durations.short4,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (expandedIndex == index) {
                                      expandedIndex = null;
                                    } else {
                                      expandedIndex = index;
                                    }
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: aspectRatio * 50,
                                      width: aspectRatio * 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: colorData.backgroundColor(1),
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: index.toString(),
                                        weight: FontWeight.bold,
                                        size: sizeData.subHeader,
                                        color: colorData.primaryColor(1),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        text: testFields[index].question,
                                        maxLine: 5,
                                        color: colorData.fontColor(.7),
                                        weight: FontWeight.w700,
                                        height: 1.15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "ANS:",
                                    color: colorData.fontColor(.5),
                                    weight: FontWeight.w700,
                                    size: sizeData.small,
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                      text: testFields[index]
                                          .options[testFields[index].answer]!,
                                      color: colorData.fontColor(.8),
                                      weight: FontWeight.w800,
                                      height: 1.15,
                                      maxLine: 3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: toExpand ? height * 0.02 : 0,
                              ),
                              ...List.generate(
                                  toExpand
                                      ? testFields[index].options.length
                                      : 0, (optionIndex) {
                                MapEntry<String, String> option =
                                    testFields[index]
                                        .options
                                        .entries
                                        .toList()[optionIndex];

                                bool isAnswer =
                                    testFields[index].answer == option.key;

                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: height * 0.01,
                                    left: width * 0.01,
                                    right: width * 0.01,
                                  ),
                                  padding: isAnswer
                                      ? EdgeInsets.symmetric(
                                          vertical: height * 0.005,
                                          horizontal: width * 0.01)
                                      : null,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        isAnswer ? Colors.green.shade100 : null,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "${option.key}: ",
                                        color: colorData.fontColor(.8),
                                        weight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          text: option.value,
                                          color: colorData.fontColor(.6),
                                          weight: FontWeight.w700,
                                          maxLine: 3,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
              ): Image.asset("assets/images/add_question.png"),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => onSubmit(),
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.04, top: height * 0.03),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.015, horizontal: width * 0.06),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorData.primaryColor(.4),
                          colorData.primaryColor(
                            .8,
                          ),
                        ],
                      ),
                    ),
                    child: CustomText(
                      text: "CREATE LIVE TEST",
                      color: colorData.sideBarTextColor(1),
                      size: sizeData.medium,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
