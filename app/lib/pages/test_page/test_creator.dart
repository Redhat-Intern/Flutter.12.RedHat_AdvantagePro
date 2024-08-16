import 'dart:io';

import 'package:Vectra/utilities/console_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/page_header.dart';
import '../../components/common/text.dart';
import '../../components/test/add_testfield_page.dart';
import '../../components/test/ai_generate_testfield_page.dart';
import '../../model/test.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class TestCreater extends ConsumerStatefulWidget {
  const TestCreater(
      {super.key,
      required this.batchData,
      required this.dayIndex,
      required this.day,
      required this.testType});
  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;
  final TestType testType;

  @override
  ConsumerState<TestCreater> createState() => _TestCreaterState();
}

class _TestCreaterState extends ConsumerState<TestCreater> {
  TextEditingController timeCtr = TextEditingController();
  int? expandedIndex;
  List<TestField> testFields = [];

  void addTestField(TestField testField) {
    setState(() {
      testFields.add(testField);
    });
  }

  void editTestField(TestField testField, int index) {
    setState(() {
      testFields.replaceRange(index, index + 1, [testField]);
    });
  }

  void readExcelFile(File file) async {
    var bytes = file.readAsBytesSync();
    var excel = ex.Excel.decodeBytes(bytes);

    List<List<ex.Data?>> sheet = excel[excel.getDefaultSheet()!].rows;
    List<List<String>> excelData = [];

    if (sheet.isNotEmpty) {
      for (var row in sheet.sublist(1)) {
        List<String> rowStrings = [];
        for (var index = 0; index < 6; index++) {
          row[index]?.value != null
              ? rowStrings.add(row[index]!.value.toString())
              : null;
        }
        if (rowStrings.isNotEmpty) {
          excelData.add(rowStrings);
        }
      }

      List<TestField> testFiledList = [];
      for (List<String> element in excelData) {
        testFiledList.add(TestField(
            element[0],
            {
              'o1': element[1],
              'o2': element[2],
              'o3': element[3],
              'o4': element[4]
            },
            element[5]));
      }
      setState(() {
        testFields.addAll(testFiledList);
      });
    } else {
      ConsoleLogger.error("Error while uploading data", from: "test_creator");
    }
  }

  void onSubmit() {
    if (timeCtr.text != ""
        // && testFields.isNotEmpty
        ) {
      String collectionName =
          widget.testType == TestType.live ? "live" : "daily";
      FirebaseFirestore.instance
          .collection("${collectionName}Test")
          .doc(widget.batchData["name"])
          .set({
        widget.dayIndex.toString(): {
          "duration": timeCtr.text.trim(),
          "data": testFields.map((e) => e.toMap()).toList(),
        }
      }, SetOptions(merge: true));

      if (widget.testType == TestType.daily) {
        FirebaseFirestore.instance
            .collection("batches")
            .doc(widget.batchData["name"])
            .set({
          "dailyTest": {widget.dayIndex.toString(): true}
        }, SetOptions(merge: true));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child: CustomText(
            text:
                "${widget.testType.name[0].toUpperCase() + widget.testType.name.substring(1)} Test added successfully!",
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

    bool isLive = widget.testType == TestType.live;

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
              PageHeader(
                tittle: "${widget.testType.name.toUpperCase()} TEST",
                isMenuButton: false,
                secondaryWidget: CustomText(
                  text: widget.day,
                  size: sizeData.medium,
                  color: colorData.fontColor(.6),
                  weight: FontWeight.w800,
                  height: height * 0.0028,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Test Duration ",
                          weight: FontWeight.w800,
                          color: colorData.fontColor(.8),
                          size: sizeData.medium,
                        ),
                        CustomText(
                          text: isLive
                              ? "(in seconds for each question):"
                              : "(total time in minutes for all questions):",
                          color: colorData.fontColor(.6),
                          size: sizeData.small,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: width * .2,
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
                          hintText: isLive ? "seconds" : "minutes",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? excelSheetResult =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        allowedExtensions: ["csv", "xlsx", "xls", "gsheet"],
                        type: FileType.custom,
                        allowCompression: true,
                      );
                      if (excelSheetResult != null) {
                        PlatformFile excelSheet = excelSheetResult.files.first;
                        File fileData = File(excelSheet.path.toString());
                        readExcelFile(fileData);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.006,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: colorData.secondaryColor(.3),
                        border: Border.all(
                          color: colorData.secondaryColor(1),
                          strokeAlign: BorderSide.strokeAlignInside,
                          width: 3,
                        ),
                      ),
                      child: CustomText(
                        text: "EXCEL",
                        weight: FontWeight.w900,
                        color: colorData.primaryColor(1),
                        fontFamily: FontFamilyENUM.Merriweather.name,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionSet(
                            function: addTestField, from: From.add),
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
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AiGenerateTestfieldPage(
                          addTestField: addTestField,
                          from: 'daily',
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.006,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: colorData.secondaryColor(.3),
                        border: Border.all(
                          color: colorData.secondaryColor(1),
                          strokeAlign: BorderSide.strokeAlignInside,
                          width: 3,
                        ),
                      ),
                      child: CustomText(
                        text: "AI ✨",
                        weight: FontWeight.w900,
                        color: colorData.primaryColor(1),
                        fontFamily: FontFamilyENUM.Merriweather.name,
                      ),
                    ),
                  ),
                ],
              ),
              testFields.isNotEmpty
                  ? GestureDetector(
                      onTap: () => setState(() {
                        testFields = [];
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: height * 0.015),
                        alignment: Alignment.centerLeft,
                        child: const CustomText(
                            text: "CLEAR ALL", color: Colors.red),
                      ),
                    )
                  : SizedBox(
                      height: height * 0.02,
                    ),
              testFields.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: testFields.length,
                          itemBuilder: (context, index) {
                            bool toExpand = expandedIndex == index;
                            return Stack(
                              children: [
                                AnimatedContainer(
                                  duration: Durations.long2,
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.02),
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorData.secondaryColor(.3),
                                      border: Border.all(
                                        color: colorData.secondaryColor(.5),
                                      )),
                                  child: AnimatedSize(
                                    duration: Durations.long2,
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
                                          onLongPress: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddQuestionSet(
                                                  function: editTestField,
                                                  from: From.edit,
                                                  index: index,
                                                  testField: testFields[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: aspectRatio * 50,
                                                    width: aspectRatio * 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: colorData
                                                          .backgroundColor(1),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: CustomText(
                                                      text: (index + 1)
                                                          .toString(),
                                                      weight: FontWeight.bold,
                                                      size: sizeData.subHeader,
                                                      color: colorData
                                                          .primaryColor(1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Expanded(
                                                    child: CustomText(
                                                      text: testFields[index]
                                                          .question,
                                                      maxLine: 8,
                                                      color: colorData
                                                          .fontColor(.6),
                                                      weight: FontWeight.w700,
                                                      height: 1.35,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CustomText(
                                                    text: "ANS:",
                                                    color:
                                                        colorData.fontColor(.5),
                                                    weight: FontWeight.w700,
                                                    size: sizeData.tooSmall,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Expanded(
                                                    child: CustomText(
                                                      text: (testFields[index]
                                                              .options[
                                                          testFields[index]
                                                              .answer])!,
                                                      color: colorData
                                                          .fontColor(1),
                                                      weight: FontWeight.w800,
                                                      size: sizeData.medium,
                                                      height: 1.25,
                                                      maxLine: 3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: toExpand ? height * 0.01 : 0,
                                        ),
                                        if (toExpand)
                                          Divider(
                                            endIndent: width * 0.02,
                                            indent: width * 0.02,
                                            color: colorData.fontColor(.1),
                                          ),
                                        SizedBox(
                                          height: toExpand ? height * 0.01 : 0,
                                        ),
                                        ...List.generate(
                                            toExpand
                                                ? testFields[index]
                                                    .options
                                                    .length
                                                : 0, (optionIndex) {
                                          MapEntry<String, String> option =
                                              testFields[index]
                                                  .options
                                                  .entries
                                                  .toList()[optionIndex];

                                          bool isAnswer =
                                              testFields[index].answer ==
                                                  option.key;

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
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: isAnswer
                                                  ? Colors.green.shade100
                                                  : null,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: "${option.key}: ",
                                                  color:
                                                      colorData.fontColor(.6),
                                                  weight: FontWeight.bold,
                                                ),
                                                SizedBox(
                                                  width: width * 0.01,
                                                ),
                                                Expanded(
                                                  child: CustomText(
                                                    text: option.value,
                                                    color:
                                                        colorData.fontColor(.6),
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
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      setState(
                                          () => testFields.removeAt(index));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          content: Center(
                                              child: Text(
                                                  "Deleted TestField of index ${index + 1}")),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    )
                  : Image.asset("assets/images/add_question.png"),
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
                      text: "CREATE ${widget.testType.name.toUpperCase()} TEST",
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
