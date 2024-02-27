import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../add_certificate/course_file_tile.dart';
import '../../common/text.dart';

class CourseFiles extends ConsumerStatefulWidget {
  final Map<String, dynamic> courseFiles;
  const CourseFiles({super.key, required this.courseFiles});

  @override
  ConsumerState<CourseFiles> createState() => _CourseFilesState();
}

class _CourseFilesState extends ConsumerState<CourseFiles> {
  Map<File, Map<String, dynamic>> dynamicCourseFiles = {};
  Future<File?> downloadFile(String path, String name) async {
    try {
      final response = await Dio()
          .get(path, options: Options(responseType: ResponseType.bytes));

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$name';
      final file = await File(filePath).writeAsBytes(response.data);
      return file;
    } catch (e) {
      return null;
    }
  }

  void updateCourseFiles() {
    dynamicCourseFiles.clear();
    widget.courseFiles.forEach((key, value) async {
      File? file = await downloadFile(key, value["name"]);
      if (file != null) {
        setState(() {
          dynamicCourseFiles.addAll({file: value});
        });
      }
    });
  }

  @override
  void didUpdateWidget(CourseFiles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.courseFiles.keys.first != oldWidget.courseFiles.keys.first) {
      updateCourseFiles();
    }
  }

  @override
  void initState() {
    super.initState();
    updateCourseFiles();
  }

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          height: height*.225,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DottedBorder(
                color: colorData.secondaryColor(.6),
                padding: const EdgeInsets.all(4),
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
                dashPattern: const [14, 4, 6, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                child: widget.courseFiles.isEmpty
                    ? Center(
                        child: CustomText(
                          text: "The course files have not been uploaded yet",
                          align: TextAlign.center,
                          size: sizeData.medium,
                          color: colorData.fontColor(.3),
                          weight: FontWeight.w600,
                          maxLine: 6,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.courseFiles.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.02,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          bool canShow = index < dynamicCourseFiles.length;
                          if (canShow) {
                            MapEntry<File, Map<String, dynamic>> thisFileMap =
                                dynamicCourseFiles.entries.toList()[index];
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
          
                            return FileTile(
                              fileData: fileData,
                              isImage: isImage,
                              extension: extension,
                              name: name,
                              fileSize: fileSize,
                            );
                          } else {
                            return Container(
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
                                  Shimmer.fromColors(
                                    baseColor: colorData.secondaryColor(.5),
                                    highlightColor: colorData.primaryColor(.3),
                                    child: Container(
                                      height: aspectRatio * 100,
                                      width: aspectRatio * 100,
                                      margin: EdgeInsets.only(
                                        top: height * 0.005,
                                        bottom: height * 0.005,
                                        left: width * 0.01,
                                        right: width * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: colorData.secondaryColor(.5),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: colorData.secondaryColor(.5),
                                        highlightColor:
                                            colorData.secondaryColor(.1),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: height * 0.0125),
                                          width: width * 0.5,
                                          height: height * 0.02,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: colorData.secondaryColor(1),
                                          ),
                                        ),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: colorData.secondaryColor(.5),
                                        highlightColor:
                                            colorData.secondaryColor(.1),
                                        child: Container(
                                          width: width * 0.2,
                                          height: height * 0.02,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: colorData.secondaryColor(1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
              ),
              dynamicCourseFiles.isNotEmpty
                  ? Positioned(
                      top: -15,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(aspectRatio * 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorData.primaryColor(1),
                        ),
                        child: CustomText(
                          text: dynamicCourseFiles.length.toString(),
                          size: sizeData.regular,
                          color: colorData.sideBarTextColor(1),
                          weight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class FileTile extends ConsumerWidget {
  const FileTile({
    super.key,
    required this.fileData,
    required this.isImage,
    required this.extension,
    required this.name,
    required this.fileSize,
  });

  final File fileData;
  final bool isImage;
  final String extension;
  final String name;
  final String fileSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

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
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                          image: FileImage(fileData), fit: BoxFit.cover),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CouseFileTile(value: name, field: "Name: "),
                CouseFileTile(value: fileSize, field: "Size: "),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
