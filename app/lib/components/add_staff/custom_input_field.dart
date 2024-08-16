import 'package:Vectra/utilities/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';

class CustomInputField extends ConsumerWidget {
  const CustomInputField({
    super.key,
    this.controller,
    required this.hintText,
    required this.icon,
    required this.inputType,
    this.readOnly = false,
    this.bottomMar,
    this.visibleText = true,
    this.listener,
    this.initialValue,
    this.isAuth = false,
  });
  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final bool readOnly;
  final double? bottomMar;
  final bool visibleText;
  final Function? listener;
  final String? initialValue;
  final bool? isAuth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    double aspectRatio = sizeData.aspectRatio;

    Color fontColor(double opacity) => isAuth!
        ? const Color(0XFF1C2136).withOpacity(opacity)
        : colorData.fontColor(opacity);
    Color secondaryColor(double opacity) => isAuth!
        ? Colors.white.withOpacity(opacity)
        : colorData.secondaryColor(opacity);

    Color primaryColor(double opacity) => isAuth!
        ? primaryColors[0].withOpacity(opacity)
        : colorData.primaryColor(opacity);

    return Container(
      height: height * 0.045,
      margin: EdgeInsets.only(
        bottom: bottomMar ?? height * 0.0175,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor(.4),
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
                  primaryColor(.6),
                  primaryColor(.3),
                ],
              ),
            ),
            child: CustomIcon(
              icon: icon,
              color: secondaryColor(1),
              size: aspectRatio * 45,
            ),
          ),
          Expanded(
            child: TextFormField(
              readOnly: readOnly,
              initialValue: initialValue,
              controller: controller,
              keyboardType: inputType,
              onChanged: (value) {
                if (listener != null) {
                  listener!(value);
                }
              },
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: sizeData.regular,
                color: fontColor(.8),
                // height: 1,
              ),
              cursorColor: primaryColor(1),
              cursorWidth: 2,
              obscureText: !visibleText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeData.regular,
                  color: fontColor(.5),
                  // height: 1,
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
