import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/Onboarding.dart';
import 'Pages/Navigation.dart';

bool? isFirstTimeView;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPrefernces = await SharedPreferences.getInstance();
  isFirstTimeView = sharedPrefernces.getBool('isFirstTimeView') ?? true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFirstTimeView == true ? const Onboarding() : const Navigation(),
    );
  }
}
