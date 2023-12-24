import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../static_data.dart';

class ThemeProviderNotifier extends StateNotifier<Map<ThemeMode, Color>> {
  ThemeProviderNotifier() : super({ThemeMode.light: primaryColors[0]});

  void toggleThemeMode(bool ison) {
    state = {ison ? ThemeMode.dark : ThemeMode.light: state.values.first};
  }

  void changePrimaryColor(Color color) {
    state = {state.keys.first: color};
  }
}

final themeProvider =
    StateNotifierProvider<ThemeProviderNotifier, Map<ThemeMode, Color>>(
        (ref) => ThemeProviderNotifier());

mixin CustomThemeDataMixin {
  final lightTheme = ThemeData(
    fontFamily: "Nato",
    scaffoldBackgroundColor: const Color(0xffDADEEC),
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(
      color: Color(0XFF1C2136),
    ),
  );

  final darkTheme = ThemeData(
    fontFamily: "Nato",
    scaffoldBackgroundColor: const Color(0XFF22223D),
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
