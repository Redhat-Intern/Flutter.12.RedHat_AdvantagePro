import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../../model/course_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../add_certificate/course_file_tile.dart';
import '../../common/text.dart';

class CourseFiles extends ConsumerStatefulWidget {
  final CourseData content;
  const CourseFiles(
      {super.key, required this.content});

  @override
  ConsumerState<CourseFiles> createState() => _CourseFilesState();
}

class _CourseFilesState extends ConsumerState<CourseFiles> {
  Map<File, Map<String, dynamic>> courseFiles = {};

  @override
  Widget build(BuildContext context) {
    courseFiles = widget.content.files;

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Files:",
          size: sizeData.regular,
          color: colorData.fontColor(.6),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * 0.015,
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            DottedBorder(
              color: colorData.secondaryColor(.4),
              padding: const EdgeInsets.all(4),
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
              dashPattern: const [14, 4, 6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              child: Container(
                height: height * 0.225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: courseFiles.isEmpty
                    ? Center(
                        child: CustomText(
                          text: "The course files have not been uploaded yet",
                          align: TextAlign.center,
                          size: sizeData.medium,
                          color: colorData.secondaryColor(.4),
                          weight: FontWeight.w600,
                          maxLine: 6,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: courseFiles.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.02,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          MapEntry<File, Map<String, dynamic>> thisFileMap =
                              courseFiles.entries.toList()[index];
                          File fileData = thisFileMap.key;
                          String extension = thisFileMap.value["extension"];
                          bool isImage =
                              extension == "png" || extension == "jpg";
                          String name = thisFileMap.value["name"];
                          int size =
                              int.parse(thisFileMap.value["size"].toString());
                          double kb = size / 1024;
                          double mb = kb / 1024;

                          String fileSize = mb >= 1
                              ? "${mb.toStringAsFixed(2)} MBs"
                              : "${kb.toStringAsFixed(2)} KBs";

                          return GestureDetector(
                            onTap: () {
                              OpenFile.open(fileData.path);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorData.secondaryColor(.5),
                                    colorData.secondaryColor(.1),
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: aspectRatio * 100,
                                    width: aspectRatio * 100,
                                    margin: EdgeInsets.only(
                                      top: height * 0.005,
                                      bottom: height * 0.005,
                                      left: width * 0.01,
                                      right: width * 0.02,
                                    ),
                                    decoration: isImage
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            image: DecorationImage(
                                                image: FileImage(fileData),
                                                fit: BoxFit.cover),
                                          )
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                colorData.primaryColor(.3),
                                                colorData.primaryColor(.1),
                                              ],
                                            ),
                                          ),
                                    child: isImage
                                        ? const SizedBox()
                                        : Center(
                                            child: CustomText(
                                              text: extension.toUpperCase(),
                                              size: sizeData.regular,
                                              color: colorData.fontColor(.8),
                                              weight: FontWeight.w800,
                                            ),
                                          ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CouseFileTile(
                                          value: name, field: "Name: "),
                                      CouseFileTile(
                                          value: fileSize, field: "Size: "),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            courseFiles.isNotEmpty
                ? Positioned(
                    top: -10,
                    right: -5,
                    child: Container(
                      padding: EdgeInsets.all(aspectRatio * 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorData.primaryColor(1),
                      ),
                      child: CustomText(
                        text: courseFiles.length.toString(),
                        size: sizeData.regular,
                        color: colorData.sideBarTextColor(1),
                        weight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
