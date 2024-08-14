import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestartNotifier extends StateNotifier<GlobalKey> {
  RestartNotifier() : super(GlobalKey());

  void restart() {
    state = GlobalKey();
  }
}

final restartProvider = StateNotifierProvider<RestartNotifier, GlobalKey>(
    (ref) => RestartNotifier());
