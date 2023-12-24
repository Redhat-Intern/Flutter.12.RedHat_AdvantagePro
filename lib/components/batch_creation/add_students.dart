import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';
import '../common/icon.dart';

class AddStudents extends ConsumerWidget {
  const AddStudents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;
    return Container(
      child: Column(
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
              CustomText(
                text: "Upload student data in excel : ",
                size: sizeData.regular,
                color: colorData.fontColor(.6),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              GestureDetector(
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
                    )),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            children: [
              GestureDetector(
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
      ),
    );
  }
}
