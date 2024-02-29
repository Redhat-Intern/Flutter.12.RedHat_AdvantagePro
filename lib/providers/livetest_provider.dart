// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveTestNotifier extends StateNotifier<Map<String, dynamic>?> {
  LiveTestNotifier() : super(null);

  void updateTestData(Map<String, dynamic> data) {
    state = data;
  }
}

final liveTestProvider =
    StateNotifierProvider<LiveTestNotifier, Map<String, dynamic>?>(
        (ref) => LiveTestNotifier());
