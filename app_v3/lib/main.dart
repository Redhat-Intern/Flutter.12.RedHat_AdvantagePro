// Core imports for Flutter, Firebase, and state management
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports for app-specific screens and providers
import 'layout/obscreen.dart';
import 'providers/restart_provider.dart';
import 'utilities/theme/theme_provider.dart';
import 'functions/firebase_options.dart';
import 'layout/splash.dart';

// Track if it's the first time viewing the app
bool? isFirstTimeView;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter

  // Initialize Firebase with platform-specific settings
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get shared preferences to check first-time view status
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isFirstTimeView = preferences.getBool('isFirstTimeView') ?? true;

  // Set app orientation to portrait mode only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Start the app with Riverpod state management
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget with CustomThemeDataMixin {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current theme mode from Riverpod provider
    ThemeMode themeMode = ref.watch(themeProvider).keys.first;

    return MaterialApp(
      title: "Vectra", // Application title
      key: ref.watch(restartProvider), // Key for app restart
      debugShowCheckedModeBanner: false, // Remove debug banner
      themeMode: themeMode, // Apply theme mode
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      home: isFirstTimeView == true ? const OBScreen() : const Splash(),
      // Choose initial screen based on first-time view flag
    );
  }
}
