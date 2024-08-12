import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../add_course/course_file_tile.dart';
import '../../common/text.dart';

class FileTile extends ConsumerWidget {
  const FileTile({
    super.key,
    required this.fileData,
    required this.isImage,
    required this.extension,
    required this.name,
    this.fileSize,
  });

  final File fileData;
  final bool isImage;
  final String extension;
  final String name;
  final String? fileSize;

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
                fileSize != null
                    ? CouseFileTile(value: fileSize!, field: "Size: ")
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
