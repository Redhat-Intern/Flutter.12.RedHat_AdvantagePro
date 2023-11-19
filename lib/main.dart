import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utilities/static_data.dart';
import 'Utilities/theme/theme_provider.dart';
import 'firebase/firebase_options.dart';

import 'Pages/Splash.dart';
import 'pages/onboarding.dart';

bool? isFirstTimeView;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences sharedPrefernces = await SharedPreferences.getInstance();
  isFirstTimeView = sharedPrefernces.getBool(firstTimeView) ?? true;

  runApp( ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget with CustomThemeDataMixin{
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lighttheme,
      darkTheme: darktheme,
      home: isFirstTimeView == true ? const Onboarding() : const Splash(),
    );
  }
}
