import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateNotifier extends StateNotifier<AppLifecycleState> {
  AppStateNotifier() : super(AppLifecycleState.resumed);

  void setAppState({required AppLifecycleState lifecycle}) {
    state = lifecycle;
  }
}

final appLifecycleStateProvider =
    StateNotifierProvider<AppStateNotifier, AppLifecycleState>(
        (ref) => AppStateNotifier());
