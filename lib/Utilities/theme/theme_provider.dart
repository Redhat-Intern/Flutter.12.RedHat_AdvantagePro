import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> with CustomThemeDataMixin {
  ThemeNotifier() : super(ThemeMode.light);

  bool isDark() => state == ThemeMode.dark;

  // True = Dark , False = Light
  void toggleThemeMode(bool ison) {
    state = ison ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData customThemeData() =>
      state == ThemeMode.dark ? darktheme : lighttheme;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

mixin CustomThemeDataMixin {
  final darktheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xffDADEEC),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.white));

  final lighttheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(51, 51, 51, 1),
      colorScheme: const ColorScheme.dark(),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.black));
}
