import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../static_data.dart';

// Notifier for managing theme mode and primary color
class ThemeProviderNotifier extends StateNotifier<Map<ThemeMode, Color>> {
  // Initialize with light theme and default primary color
  ThemeProviderNotifier() : super({ThemeMode.light: primaryColors[0]});

  // Toggle between light and dark theme modes
  void toggleThemeMode(bool isDarkMode) {
    state = {isDarkMode ? ThemeMode.dark : ThemeMode.light: state.values.first};
  }

  // Change the primary color of the current theme
  void changePrimaryColor(Color color) {
    state = {state.keys.first: color};
  }
}

// Provider for managing theme state
final themeProvider =
    StateNotifierProvider<ThemeProviderNotifier, Map<ThemeMode, Color>>(
  (ref) => ThemeProviderNotifier(),
);

// Mixin for providing theme data
mixin CustomThemeDataMixin {
  // Light theme configuration
  final ThemeData lightTheme = ThemeData(
    // Optionally set fontFamily here
    scaffoldBackgroundColor: const Color.fromARGB(255, 252, 252, 255),
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Color(0XFF1C2136)),
  );

  // Dark theme configuration
  final ThemeData darkTheme = ThemeData(
    // Optionally set fontFamily here
    scaffoldBackgroundColor: const Color(0XFF22223D),
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
