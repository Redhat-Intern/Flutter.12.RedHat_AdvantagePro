// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationIndexNotifier extends StateNotifier<int> {
  NavigationIndexNotifier() : super(0);

  void jumpTo(int index) {
    state = index;
  }
}

final navigationIndexNotifier =
    StateNotifierProvider<NavigationIndexNotifier, int>(
        (ref) => NavigationIndexNotifier());
