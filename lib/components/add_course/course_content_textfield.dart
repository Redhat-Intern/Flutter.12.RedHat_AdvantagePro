import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/shimmer_box.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class CourseContentInputField extends ConsumerWidget {
  const CourseContentInputField({
    super.key,
    this.controller,
    this.hintText,
    required this.header,
    required this.from,
    this.text,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String header;
  final From from;
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Row(
      children: [
        CustomText(
          text: header,
          size: sizeData.regular,
          color: colorData.fontColor(.6),
          weight: FontWeight.w800,
        ),
        SizedBox(
          width: width * 0.01,
        ),
        Expanded(
          child: from == From.detail && text == null
              ? ShimmerBox(height: height * 0.0375, width: width)
              : Container(
                  height: height * 0.0375,
                  padding: EdgeInsets.only(left: width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        colorData.secondaryColor(.2),
                        colorData.secondaryColor(.4)
                      ],
                    ),
                  ),
                  child: TextFormField(
                    controller: controller,
                    initialValue: text,
                    readOnly: from == From.detail,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeData.regular,
                      color: colorData.fontColor(.8),
                      height: 1,
                    ),
                    cursorColor: colorData.primaryColor(1),
                    cursorWidth: 2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height * 0.02),
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.regular,
                        color: colorData.fontColor(.5),
                        height: 1,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
