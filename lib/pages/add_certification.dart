import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';
import 'package:redhat_v1/functions/create/create_certficate.dart';
import 'package:redhat_v1/providers/navigation_index_provider.dart';

import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import '../model/course_data.dart';

import '../components/add_certificate/certificate_pdf_picker.dart';
import '../components/add_certificate/course_content_textfield.dart';
import '../components/add_certificate/details_inputfield.dart';
import '../components/add_certificate/course_files.dart';
import '../components/common/menu_button.dart';
import '../components/common/text.dart';

class AddCertification extends ConsumerStatefulWidget {
  const AddCertification({super.key});

  @override
  ConsumerState<AddCertification> createState() => _addCertificateState();
}

class _addCertificateState extends ConsumerState<AddCertification> {
  TextEditingController name = TextEditingController();
  TextEditingController discription = TextEditingController();

  TextEditingController topics = TextEditingController();
  TextEditingController title = TextEditingController();

  Map<int, String> completionCount = {};

  Map<int, CourseData> courseContent = {
    0: CourseData(files: {}, title: "", topics: "")
  };

  Map<File, String> image = {};
  Map<File, String> coursePDF = {};
  int firstIndex = 0;

  void clearData() {
    setState(() {
      name.clear();
      image.clear();
      discription.clear();
      topics.clear();
      title.clear();
      completionCount.clear();
      courseContent = {0: CourseData(files: {}, title: "", topics: "")};
      firstIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    clearData();
    title.addListener(() {
      CourseData currentData = courseContent[firstIndex]!;
      currentData.title = title.text;
    });
    topics.addListener(() {
      CourseData currentData = courseContent[firstIndex]!;
      currentData.topics = topics.text;
    });
  }

  void dayChange({required int day}) {
    setState(() {
      CourseData currentData = courseContent[day]!;
      title.text = currentData.title;
      topics.text = currentData.topics;
    });
  }

  bool hasDuplicate(
      {required MapEntry<File, Map<String, dynamic>> courseFile,
      required CourseData currentData}) {
    bool isDuplicate = false;
    currentData.files.forEach((key, value) {
      if (value["name"] == courseFile.value["name"]) {
        isDuplicate = true;
      }
    });
    return !isDuplicate;
  }

  void handleFile(
      {required MapEntry<File, Map<String, dynamic>> file, required bool set}) {
    setState(() {
      CourseData currentData = courseContent[firstIndex]!;
      if (set) {
        if (hasDuplicate(courseFile: file, currentData: currentData)) {
          currentData.files.addEntries([file]);
        }
      } else {
        currentData.files.remove(file.key);
      }
    });
  }

  void setCertificateImage(File image, String imageName) {
    setState(() {
      this.image = {image: imageName};
    });
  }

  void setCoursePDF(File pdf, String pdfName) {
    setState(() {
      coursePDF = {pdf: pdfName};
    });
  }

  void setCourseContent(Map<int, CourseData> courseContent) {
    setState(() {
      this.courseContent = courseContent;
    });
  }

  void removeCourseContent(int day) {
    setState(() {
      courseContent.remove(day);
    });
  }

  void addToFirestore({
    required CustomSizeData sizeData,
    required CustomColorData colorData,
  }) async {
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;
    bool check = false;

    courseContent.forEach((key, value) {
      if (value.title.isEmpty || value.topics.isEmpty || value.files.isEmpty) {
        check = true;
      }
    });

    if (name.text.isEmpty ||
        discription.text.isEmpty ||
        image.isEmpty ||
        coursePDF.isEmpty ||
        courseContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "Kindly enter all the data",
            ),
          ),
        ),
      );
    } else if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "Kindly fill all the fields in cource content",
            ),
          ),
        ),
      );
    } else {
      setState(() {
        completionCount = {0: "Started"};
      });

      createCertificate(
        image: image,
        nameController: name,
        discriptionController: discription,
        pdf: coursePDF,
        courseContent: courseContent,
      ).listen((event) {
        setState(() {
          if (event.keys.first == 1) {
            completionCount = {1: "Image uploaded"};
          } else if (event.keys.first == 2) {
            completionCount = {2: "PDF uploaded"};
          } else if (event.keys.first == 3) {
            completionCount = event;
          } else if (event.keys.first == 4) {
            clearData();
            ref.read(navigationIndexProvider.notifier).jumpTo(0);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    discription.dispose();
    title.dispose();
    topics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return completionCount.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const MenuButton(),
                  const Spacer(),
                  CustomText(
                    text: "Create Certificates",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () {
                      addToFirestore(
                        colorData: colorData,
                        sizeData: sizeData,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          right: width * 0.01, left: width * 0.05),
                      padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.02,
                        top: height * 0.005,
                        bottom: height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.3),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            CustomIcon(
                              size: aspectRatio * 45,
                              icon: Icons.add_rounded,
                              color: colorData.primaryColor(1),
                            ),
                            CustomText(
                              text: "ADD",
                              size: sizeData.regular,
                              color: colorData.primaryColor(1),
                              weight: FontWeight.w800,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              CertificateDetail(
                discription: discription,
                name: name,
                imageSetter: setCertificateImage,
              ),
              SizedBox(
                height: height * .03,
              ),
              CertificatePDF(
                setter: setCoursePDF,
              ),
              SizedBox(
                height: height * .03,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Course content",
                          size: sizeData.medium,
                          color: colorData.fontColor(.8),
                          weight: FontWeight.w800,
                        ),
                        Tooltip(
                          message: "Long press a day to remove it",
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorData.fontColor(.6),
                            fontSize: sizeData.small,
                          ),
                          waitDuration: const Duration(microseconds: 1),
                          showDuration: const Duration(seconds: 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorData.secondaryColor(.8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorData.secondaryColor(.5),
                            ),
                            child: CustomIcon(
                              size: aspectRatio * 32,
                              icon: Icons.question_mark_rounded,
                              color: colorData.primaryColor(1),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                      height: height * 0.06,
                      padding: EdgeInsets.only(
                        left: width * 0.03,
                        top: height * 0.006,
                        bottom: height * 0.006,
                      ),
                      decoration: BoxDecoration(
                        color: colorData.secondaryColor(.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.005,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: courseContent.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    firstIndex = index;
                                    dayChange(day: index);
                                  }),
                                  onLongPress: () {
                                    firstIndex = index - 1;
                                    if (index > 0) {
                                      removeCourseContent(index);
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.03),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: height * 0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: colorData.secondaryColor(
                                          firstIndex == index ? .4 : .3),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        text: "Day $index",
                                        size: sizeData.regular,
                                        color: firstIndex == index
                                            ? colorData.primaryColor(.8)
                                            : colorData.fontColor(.4),
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              courseContent.addAll({
                                courseContent.length:
                                    CourseData(files: {}, title: "", topics: "")
                              });
                            }),
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.01, left: width * 0.03),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.025,
                                vertical: height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorData.secondaryColor(.3),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: "Add Day",
                                  size: sizeData.regular,
                                  color: colorData.primaryColor(.8),
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: colorData.secondaryColor(.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            CourseContentInputField(
                              controller: title,
                              header: "Title: ",
                              hintText: "Main topic of the day",
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            CourseContentInputField(
                              controller: topics,
                              header: "Topics: ",
                              hintText: "All topics seperated by comma",
                            ),
                            //
                            SizedBox(
                              height: height * 0.01,
                            ),
                            CourseFilePicker(
                              content: courseContent[firstIndex]!,
                              handleFile: handleFile,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
            ],
          )
        : Center(
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: colorData.secondaryColor(.5),
                  blurRadius: 400,
                  spreadRadius: 400,
                ),
              ]),
              child: Center(
                child: Container(
                  // width: width * .5,
                  height: height * .23,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorData.primaryColor(.2),
                          colorData.primaryColor(.6)
                        ]),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.06,
                      ),
                      CircularProgressIndicator.adaptive(
                        strokeWidth: 8,
                        strokeAlign: 5,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(
                          colorData.primaryColor(1),
                        ),
                        value: completionCount.keys.first * 0.33,
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      CustomText(
                        text: completionCount.values.first,
                        size: sizeData.medium,
                        color: colorData.secondaryColor(1),
                        weight: FontWeight.w600,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
