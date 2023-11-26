import 'package:flutter/material.dart';

class CustomColorData {
  final Color Function(double) fontColor;

  final Color sideBarColor;
  final Color Function(double) sideBarTextColor;
  final Color sideBarIconColor;

  CustomColorData({
    required this.fontColor,
    required this.sideBarColor,
    required this.sideBarTextColor,
    required this.sideBarIconColor,
  });

  factory CustomColorData.from(BuildContext context) {
    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    const Color sideBarColor = Color(0XFF5D44F8);
    Color sideBarTextColor(double opacity) => Colors.white.withOpacity(opacity);
    const Color sideBarIconColor = Color(0XFFE8AD49);

    return CustomColorData(
      fontColor: fontColor,
      sideBarColor: sideBarColor,
      sideBarTextColor: sideBarTextColor,
      sideBarIconColor: sideBarIconColor,
    );
  }
}
