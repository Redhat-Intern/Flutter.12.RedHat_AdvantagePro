import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier with CustomThemeDataMixin {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;

  // True = Dark , False = Light
  void toggleThemeMode(bool ison) {
    themeMode = ison ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

   ThemeData customThemeData() =>
      themeMode == ThemeMode.dark ? darkTheme : lightTheme;
}


mixin CustomThemeDataMixin {
  final lightTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xffDADEEC),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.white));

  final darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(51, 51, 51, 1),
      colorScheme: const ColorScheme.dark(),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.black));
}
