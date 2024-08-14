import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/back_button.dart';

import '../../model/test.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class AddQuestionSet extends ConsumerStatefulWidget {
  const AddQuestionSet({
    super.key,
    required this.addTestField,
  });
  final Function addTestField;

  @override
  ConsumerState<AddQuestionSet> createState() => _AddQuestionSetState();
}

class _AddQuestionSetState extends ConsumerState<AddQuestionSet> {
  TextEditingController questionCtr = TextEditingController();
  TextEditingController optionCtr = TextEditingController();

  Map<String, String> options = {};

  String answer = "";

  void addTestField() {
    if (questionCtr.text != "" && options.isNotEmpty && answer != "") {
      widget.addTestField(TestField(questionCtr.text.trim(), options, answer));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: CustomText(
              text: "Please fill all the fields",
              color: Colors.white,
              weight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(flex: 3,),
                  CustomText(
                    text: "CREATE QUESTION",
                    weight: FontWeight.w800,
                    size: sizeData.subHeader,
                  ),
                  const Spacer(flex: 5,),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              CustomText(
                text: "QUESTION:",
                weight: FontWeight.w800,
                color: colorData.fontColor(.7),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.02,
                ),
                // height: height * 0.035,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorData.secondaryColor(.5),
                ),
                child: TextField(
                  controller: questionCtr,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: colorData.primaryColor(1),
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter the question ",
                    hintStyle: TextStyle(
                      color: colorData.fontColor(.6),
                      fontSize: sizeData.regular,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "OPTIONS:",
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.7),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      if (optionCtr.text != "") {
                        options.addAll({
                          String.fromCharCode(65 + options.length):
                              optionCtr.text.trim()
                        });
                        optionCtr.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: CustomText(
                                text: "Please enter the option value",
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.005, horizontal: width * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: colorData.secondaryColor(1),
                      ),
                      child: CustomText(
                        text: "ADD",
                        weight: FontWeight.bold,
                        size: sizeData.medium,
                        color: colorData.primaryColor(1),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.02,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorData.secondaryColor(.5),
                ),
                child: TextField(
                  controller: optionCtr,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: colorData.primaryColor(1),
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter the Option ",
                    hintStyle: TextStyle(
                      color: colorData.fontColor(.6),
                      fontSize: sizeData.regular,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              options.isNotEmpty
                  ? Column(
                      children: List.generate(options.length, (index) {
                        bool isAnswer = answer ==
                            options.entries.toList()[index].key.toString();
                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              if (isAnswer) {
                                answer = "";
                              } else {
                                answer = options.entries
                                    .toList()[index]
                                    .key
                                    .toString();
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: width * 0.02,
                              right: width * 0.02,
                              bottom: height * 0.015,
                            ),
                            padding: isAnswer
                                ? EdgeInsets.symmetric(
                                    vertical: height * 0.008,
                                    horizontal: width * 0.02)
                                : null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: isAnswer
                                  ? Colors.green.shade200
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: aspectRatio * 50,
                                  width: aspectRatio * 50,
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: colorData.secondaryColor(1),
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: options.entries
                                        .toList()[index]
                                        .key
                                        .toString(),
                                    size: sizeData.medium,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: options.entries
                                        .toList()[index]
                                        .value
                                        .toString(),
                                    color: colorData.fontColor(.7),
                                    maxLine: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: "Add some options to choose correct answer!",
                            maxLine: 2,
                            weight: FontWeight.w700,
                            color: colorData.fontColor(.6),
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            "assets/images/idea.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
              answer.isNotEmpty
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          CustomText(
                            text: "ANSWER:",
                            weight: FontWeight.w800,
                            color: colorData.fontColor(.7),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Row(
                            children: [
                              Container(
                                height: aspectRatio * 50,
                                width: aspectRatio * 50,
                                margin: EdgeInsets.only(right: width * 0.02),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: colorData.secondaryColor(1),
                                ),
                                alignment: Alignment.center,
                                child: CustomText(
                                  text: answer,
                                  size: sizeData.medium,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: options[answer].toString(),
                                  color: colorData.fontColor(.7),
                                  maxLine: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => addTestField(),
                  child: Container(
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
                      text: "ADD THE QUESTION",
                      color: colorData.sideBarTextColor(1),
                      size: sizeData.medium,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
