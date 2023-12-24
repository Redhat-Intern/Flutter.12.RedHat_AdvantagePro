import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';

class CustomColorData {
  final Color Function(double) fontColor;
  final Color Function(double) primaryColor;
  final Color Function(double) secondaryColor;

  final Color Function(double) sideBarTextColor;

  CustomColorData({
    required this.fontColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.sideBarTextColor,
  });

  factory CustomColorData.from(WidgetRef ref) {
    Map<ThemeMode, Color> themeMap = ref.watch(themeProvider);
    ThemeMode themeMode = themeMap.keys.first;
    bool isDark = themeMode == ThemeMode.dark;
    Color statePrimaryColor = themeMap.values.first;

    Color fontColor(double opacity) => isDark
        ? const Color(0XFFEFF1FF).withOpacity(opacity)
        : const Color(0XFF1C2136).withOpacity(opacity);

    Color primaryColor(double opacity) =>
        statePrimaryColor.withOpacity(opacity);

    Color secondaryColor(double opacity) => isDark
        ? Color(0XFF333354).withOpacity(opacity)
        : Colors.white.withOpacity(opacity);

    Color sideBarTextColor(double opacity) => Colors.white.withOpacity(opacity);

    return CustomColorData(
      fontColor: fontColor,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      sideBarTextColor: sideBarTextColor,
    );
  }
}
