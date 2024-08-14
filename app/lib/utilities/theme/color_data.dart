import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';

class CustomColorData {
  final Color Function(double) fontColor;
  final Color Function(double) primaryColor;
  final Color Function(double) secondaryColor;
  final Color Function(double) backgroundColor;

  final Color Function(double) sideBarTextColor;

  CustomColorData({
    required this.fontColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.sideBarTextColor,
  });

  factory CustomColorData.from(WidgetRef ref) {
    Map<ThemeMode, Color> themeMap = ref.watch(themeProvider);
    ThemeMode themeMode = themeMap.keys.first;
    bool isDark = themeMode == ThemeMode.dark;
    Color statePrimaryColor = themeMap.values.first;

    Color fontColor(double opacity) => isDark
        ? Colors.white.withOpacity(opacity)
        : const Color(0XFF1C2136).withOpacity(opacity);

    Color primaryColor(double opacity) =>
        statePrimaryColor.withOpacity(opacity);

    Color secondaryColor(double opacity) => isDark
        ? const Color(0XFF333354).withOpacity(opacity)
        : const Color.fromARGB(255, 233, 233, 239).withOpacity(opacity);

    Color backgroundColor(double opacity) => isDark
        ? const Color(0XFF22223D)
        : const Color.fromARGB(255, 255, 255, 255);

    Color sideBarTextColor(double opacity) => Colors.white.withOpacity(opacity);

    return CustomColorData(
      fontColor: fontColor,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: backgroundColor,
      sideBarTextColor: sideBarTextColor,
    );
  }
}
