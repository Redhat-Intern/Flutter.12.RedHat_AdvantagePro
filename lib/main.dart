// All Core global plugins
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Functions and utility logics
import 'firebase/firebase_options.dart';
import 'my_app.dart';

bool? isFirstTimeView;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    // Extending the Application State to ProviderScope of RiverPod
    ProviderScope(
      child: MyApp(),
    ),
  );
}
