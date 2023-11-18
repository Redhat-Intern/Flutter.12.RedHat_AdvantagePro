import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'Pages/Onboarding.dart';
import 'Pages/Navigation.dart';

bool? isFirstTimeView;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
