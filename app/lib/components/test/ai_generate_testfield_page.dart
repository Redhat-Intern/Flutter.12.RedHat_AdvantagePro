import 'dart:convert';

import 'package:Vectra/model/test.dart';
import 'package:Vectra/utilities/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:lottie/lottie.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/page_header.dart';
import '../common/text.dart';

class AiGenerateTestfieldPage extends ConsumerStatefulWidget {
  const AiGenerateTestfieldPage({
    super.key,
    required this.addTestField,
    required this.from,
  });
  final Function addTestField;
  final String from;

  @override
  ConsumerState<AiGenerateTestfieldPage> createState() =>
      _AiGenerateTestfieldPageState();
}

class _AiGenerateTestfieldPageState
    extends ConsumerState<AiGenerateTestfieldPage> {
  TextEditingController mainTopicCtr = TextEditingController();
  TextEditingController specificationCtr = TextEditingController();
  TextEditingController countCtr = TextEditingController();
  String? toughnessLevel;
  List<String> toughnessLevels = ["EASY", "MEDIUM", "HARD"];
  bool isGenerating = false;

  void addTestFields() async {
    if (mainTopicCtr.text != "" &&
        countCtr.text != "" &&
        toughnessLevel != null) {
      // widget.addTestField(TestField(mainTopicCtr.text.trim(), options, answer));
      // Navigator.pop(context);

      final model =
          FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

      String promptText = '''
      Generate a list of ${countCtr.text} map data of format 
      {
        question: String, 
        options: { 
          O1: String, 
          O2: String, 
          O3: String, 
          O4: String 
        }, 
        answer: On
      } 
      where On defines any value of n from 1 to 4, for Redhat certification course on the topic: 
      ${mainTopicCtr.text.trim()} 
      ${specificationCtr.text.isNotEmpty ? "with main scope over the specification ${specificationCtr.text}" : ""} 
      with the toughness level of $toughnessLevel. 
      ${widget.from == "live" ? "make the question small and consized, below 10 or 15 words, and the options mostly in 2 to 5 characters, since the time for each questions is less." : ''}

      Make this return type to be in JSON data format, so that I can convert it into List<Map<String, dynamic>> 
      using the method: List<Map<String, dynamic>>.from(jsonDecode(jsonResponse)).
      make the count to be accurate as mentioned.
      ''';

      // Provide a prompt that contains text
      final prompt = [Content.text(promptText)];

      setState(() {
        isGenerating = true;
      });

      // To generate text output, call generateContent with the text input
      final response = await model.generateContent(prompt);

      // Properly escape the response text and wrap it in a list to ensure valid JSON
      String jsonResponse = response.text!.substring(
          response.text!.indexOf('['), response.text!.lastIndexOf(']') + 1);

      try {
        List<Map<String, dynamic>> resultList =
            List<Map<String, dynamic>>.from(jsonDecode(jsonResponse));

        for (var data in resultList) {
          Map<String, dynamic> fieldData = Map<String, dynamic>.from(data);
          TestField textField = TestField.fromJson(fieldData);
          widget.addTestField(textField);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
              child: Text(
            "AI CONTEXT GENERATION HAD SOME ERROR",
            textAlign: TextAlign.center,
          )),
        ));
      }

      setState(() {
        isGenerating = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                      tittle: "create questions", isMenuButton: false),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  CustomText(
                    text: "MAIN TOPIC:",
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.8),
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
                      controller: mainTopicCtr,
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
                        hintText: "Enter the TOPIC to generate questions",
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
                  CustomText(
                    text: "SPECIFICATIONS:",
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.8),
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
                      controller: specificationCtr,
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
                        hintText: "Enter the hint or area of specification",
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
                  CustomText(
                    text: "TOUGHNESS LEVEL:",
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.8),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: toughnessLevels
                        .map(
                          (element) => GestureDetector(
                            onTap: () =>
                                setState(() => toughnessLevel = element),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.006,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: toughnessLevel != element
                                    ? colorData.secondaryColor(.3)
                                    : null,
                                gradient: toughnessLevel == element
                                    ? LinearGradient(colors: [
                                        colorData.primaryColor(1),
                                        colorData.primaryColor(.4)
                                      ])
                                    : null,
                                border: Border.all(
                                  color: toughnessLevel == element
                                      ? colorData.primaryColor(.2)
                                      : colorData.secondaryColor(1),
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 3,
                                ),
                              ),
                              child: CustomText(
                                text: element,
                                weight: FontWeight.w900,
                                color: toughnessLevel == element
                                    ? colorData.secondaryColor(1)
                                    : colorData.primaryColor(1),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CustomText(
                    text: "QUESTIONS COUNT:",
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.8),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    width: width * .5,
                    padding: EdgeInsets.only(
                      left: width * 0.02,
                      right: width * 0.02,
                    ),
                    height: height * 0.04,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: colorData.secondaryColor(.5),
                    ),
                    child: TextField(
                      controller: countCtr,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        height: 1,
                        color: colorData.primaryColor(1),
                        fontWeight: FontWeight.bold,
                        fontSize: sizeData.regular,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: height * 0.02),
                        hintText: "Enter questions count",
                        hintStyle: TextStyle(
                          color: colorData.fontColor(.6),
                          fontSize: sizeData.small,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => addTestFields(),
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
                          text: "GENERATE QUESTIONS",
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
              !isGenerating
                  ? const SizedBox()
                  : Center(
                      child: Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: colorData.secondaryColor(.8),
                            blurRadius: 400,
                            spreadRadius: 400,
                          ),
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/json/generating.json",
                              width: width * .7,
                            ),
                            Lottie.asset(
                              "assets/json/loadingProgress.json",
                              width: width * .5,
                            ),
                            SizedBox(
                              height: height * 0.06,
                            ),
                            CustomText(
                              text: "Generating the questions",
                              size: sizeData.medium,
                              color: colorData.primaryColor(1),
                              weight: FontWeight.w600,
                              maxLine: 3,
                              align: TextAlign.center,
                            ),
                            SizedBox(
                              height: height * 0.1,
                            ),
                          ],
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
