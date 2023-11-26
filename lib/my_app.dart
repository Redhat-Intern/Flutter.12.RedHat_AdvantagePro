import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Utilities/theme/theme_provider.dart';

import 'layout/splash.dart';

class MyApp extends StatelessWidget with CustomThemeDataMixin {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      builder: (BuildContext context, child) {
        ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const Splash(),
        );
      },
    );
  }
}


// Have simple comments for each for each logic and import
// Clean the code without boiler-plate codes as much as possible