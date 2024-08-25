import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  const LoginTextField({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    return Container(
      margin: EdgeInsets.only(bottom: height * bottomMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor(.4),
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        obscureText: isVisible ?? false,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: sizeData.medium,
          color: fontColor(.8),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          prefixIcon: CustomIcon(
            icon: icon,
            color: fontColor(.8),
            size: aspectRatio * 55,
          ),
          suffixIcon: suffixIconData != null
              ? GestureDetector(
                  onTap: onTap,
                  child: CustomIcon(
                    icon: suffixIconData!,
                    color: fontColor(.8),
                    size: aspectRatio * 55,
                  ),
                )
              : const SizedBox(),
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sizeData.medium,
            color: fontColor(.7),
          ),
        ),
      ),
    );
  }
}
