import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';

class CustomInputField extends ConsumerWidget {
  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.inputType,
    this.readOnly = false,
    this.bottomMar,
    this.visibleText = true,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final bool readOnly;
  final double? bottomMar;
  final bool visibleText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    double aspectRatio = sizeData.aspectRatio;

    return Container(
      height: height * 0.045,
      margin: EdgeInsets.only(
        bottom: bottomMar ?? height * 0.0175,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorData.secondaryColor(.4),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: width * .03),
            height: height * 0.045,
            width: width * 0.1,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorData.primaryColor(.6),
                  colorData.primaryColor(.3),
                ],
              ),
            ),
            child: CustomIcon(
              icon: icon,
              color: colorData.secondaryColor(1),
              size: aspectRatio * 45,
            ),
          ),
          Expanded(
            child: TextField(
              readOnly: readOnly,
              controller: controller,
              keyboardType: inputType,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: sizeData.regular,
                color: colorData.fontColor(.8),
                height: 1,
              ),
              cursorColor: colorData.primaryColor(1),
              cursorWidth: 2,
              obscureText: !visibleText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeData.regular,
                  color: colorData.fontColor(.5),
                  height: 1,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  bottom: height * 0.015,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
