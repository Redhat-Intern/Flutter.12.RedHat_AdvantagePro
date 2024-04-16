// All Core global plugins
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:redhat_v1/pages/test_page/live_test_result.dart';

// Functions and utility logics
import 'utilities/theme/theme_provider.dart';
import 'functions/firebase_options.dart';
import 'layout/splash.dart';

bool? isFirstTimeView;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
    ThemeMode themeMode = ref.watch(themeProvider).keys.first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const Splash(),
    );
  }
}
