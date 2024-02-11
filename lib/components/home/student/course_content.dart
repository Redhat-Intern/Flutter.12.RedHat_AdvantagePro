
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/course_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'course_files.dart';

class CourseContent extends ConsumerStatefulWidget {
  const CourseContent({
    super.key,
  });

  @override
  ConsumerState<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends ConsumerState<CourseContent> {
  TextEditingController topics = TextEditingController();
  TextEditingController title = TextEditingController();

  Map<int, CourseData> courseContent = {
    0: CourseData(files: {}, title: "", topics: "")
  };
  int firstIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Course content",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * .01,
        ),
        Container(
          width: width,
          height: height * 0.06,
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
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
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: height * 0.005,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() {
                  firstIndex = index;
                }),
                child: Container(
                  margin: EdgeInsets.only(right: width * 0.03),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.005,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color:
                        colorData.secondaryColor(firstIndex == index ? .4 : .3),
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
        SizedBox(
          height: height * 0.01,
        ),
        AnimatedContainer(
          duration: Durations.medium3,
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
              Row(
                children: [
                  CustomText(
                    text: "Title:",
                    size: sizeData.regular,
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w800,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.008),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            colorData.secondaryColor(.2),
                            colorData.secondaryColor(.4)
                          ],
                        ),
                      ),
                      child: CustomText(
                        text: "Main topic of the day",
                        size: sizeData.regular,
                        color: colorData.fontColor(.8),
                        weight: FontWeight.w800,
                        maxLine: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Topics:",
                    size: sizeData.regular,
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w800,
                    height: 2,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: Container(
                      height: height * .1,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.008),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            colorData.secondaryColor(.2),
                            colorData.secondaryColor(.4)
                          ],
                        ),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        itemBuilder: (context, index) => CustomText(
                          text: "· Main topic of the day",
                          size: sizeData.regular,
                          color: colorData.fontColor(.8),
                          weight: FontWeight.w800,
                          height: 1.5,
                          maxLine: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //
              SizedBox(
                height: height * 0.01,
              ),
              CourseFiles(
                  content:
                      CourseData(title: "title", topics: "topics", files: {})),
            ],
          ),
        ),
      ],
    );
  }
}
