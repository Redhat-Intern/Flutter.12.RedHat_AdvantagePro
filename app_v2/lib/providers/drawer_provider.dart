import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerStateNotifier extends StateNotifier<GlobalKey<ScaffoldState>> {
  static final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  DrawerStateNotifier() : super(key);
}

final drawerKeyProvider =
    StateNotifierProvider<DrawerStateNotifier, GlobalKey<ScaffoldState>>(
        (ref) => DrawerStateNotifier());
