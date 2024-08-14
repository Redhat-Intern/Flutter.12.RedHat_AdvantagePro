import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';

class LoginTextField extends ConsumerWidget {
  final String labelText;
  final bool? isVisible;
  final IconData icon;
  final TextEditingController controller;
  final double bottomMargin;
  final bool isReadOnly;
  final VoidCallback? onTap;

  final IconData? suffixIconData;

  LoginTextField({
    this.isVisible,
    this.onTap,
    this.suffixIconData,
    super.key,
    required this.labelText,
    required this.icon,
    required this.controller,
    required this.bottomMargin,
    this.isReadOnly = false,
  });
  late bool showPassword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(bottom: height * bottomMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorData.secondaryColor(.4),
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        obscureText: isVisible ?? false,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: sizeData.medium,
          color: colorData.fontColor(.8),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          prefixIcon: CustomIcon(
            icon: icon,
            color: colorData.fontColor(.8),
            size: aspectRatio * 55,
          ),
          suffixIcon: suffixIconData != null
              ? GestureDetector(
                  onTap: onTap,
                  child: CustomIcon(
                    icon: suffixIconData!,
                    color: colorData.fontColor(.8),
                    size: aspectRatio * 55,
                  ),
                )
              : const SizedBox(),
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sizeData.medium,
            color: colorData.fontColor(.7),
          ),
        ),
      ),
    );
  }
}
