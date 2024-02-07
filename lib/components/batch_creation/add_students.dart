import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/create_batch_provider.dart';

import '../../Utilities/static_data.dart';
import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';
import '../common/icon.dart';
import 'add_individual_student_overlay.dart';
import 'add_student_overlay.dart';

class AddStudents extends ConsumerStatefulWidget {
  const AddStudents({
    super.key,
  });

  @override
  ConsumerState<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends ConsumerState<AddStudents> {
  Map<File, String> excelData = {};

  void setExcelData(Map<File, String> excelData) {
    setState(() {
      this.excelData = excelData;
      ref
          .read(createBatchProvider.notifier)
          .readExcelFile(excelData.keys.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Add Students",
          size: sizeData.medium,
          color: colorData.fontColor(.8),
          weight: FontWeight.w600,
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Upload student data in excel : ",
                    size: sizeData.regular,
                    color: colorData.fontColor(.6),
                  ),
                  excelData.isNotEmpty
                      ? CustomText(
                          text: excelData.values.first,
                          size: sizeData.regular,
                          color: colorData.primaryColor(.7),
                          weight: FontWeight.w700,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return AddStudentOverlay(setter: setExcelData);
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.015,
                  vertical: height * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorData.secondaryColor(.4),
                ),
                child: Row(
                  children: [
                    CustomIcon(
                      icon: Icons.upload_file_outlined,
                      size: aspectRatio * 40,
                      color: colorData.primaryColor(1),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    CustomText(
                      text: 'EXCEL',
                      size: sizeData.regular,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w800,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return const AddIndividualStudentOverlay(
                      from: From.add,
                    );
                  },
                );
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.015,
                    vertical: height * 0.005,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: colorData.secondaryColor(.4),
                  ),
                  child: Row(
                    children: [
                      CustomIcon(
                        icon: Icons.playlist_add_rounded,
                        size: aspectRatio * 40,
                        color: colorData.primaryColor(1),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      CustomText(
                        text: 'ADD',
                        size: sizeData.regular,
                        color: colorData.fontColor(.8),
                        weight: FontWeight.w800,
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            CustomText(
              text: " : Add students manually",
              size: sizeData.regular,
              color: colorData.fontColor(.6),
            ),
          ],
        ),
      ],
    );
  }
}
