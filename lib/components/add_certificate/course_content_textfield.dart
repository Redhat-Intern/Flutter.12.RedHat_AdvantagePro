import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class CourseContentInputField extends ConsumerStatefulWidget {
  const CourseContentInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.header,
  });

  final TextEditingController controller;
  final String hintText;
  final String header;

  @override
  ConsumerState<CourseContentInputField> createState() =>
      _CourseContentInputFieldState();
}

class _CourseContentInputFieldState
    extends ConsumerState<CourseContentInputField> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Row(
      children: [
        CustomText(
          text: widget.header,
          size: sizeData.regular,
          color: colorData.fontColor(.6),
          weight: FontWeight.w800,
        ),
        SizedBox(
          width: width * 0.01,
        ),
        Expanded(
          child: Container(
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
            child: TextField(
              // scrollPadding: EdgeInsets.only(top: 10),
              controller: widget.controller,
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
                hintText: widget.hintText,
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
