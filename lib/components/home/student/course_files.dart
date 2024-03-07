import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../common/text.dart';
import 'file_tile.dart';

class CourseFiles extends ConsumerWidget {
  final Map<File, Map<String, dynamic>> courseFiles;
  const CourseFiles({super.key, required this.courseFiles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          height: height * .225,
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
                child: courseFiles.isEmpty
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

                          return FileTile(
                            fileData: fileData,
                            isImage: isImage,
                            extension: extension,
                            name: name,
                            fileSize: fileSize,
                          );
                        },
                      ),
              ),
              courseFiles.isNotEmpty
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
        ),
      ],
    );
  }
}
