import 'package:flutter_riverpod/flutter_riverpod.dart';

class testNotifier extends StateNotifier<String> {
  testNotifier() : super("");
}

final test = StateNotifierProvider<testNotifier, String>((ref) {
  return testNotifier();
});
