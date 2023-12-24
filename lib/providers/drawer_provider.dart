import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerStateNotifier extends StateNotifier<GlobalKey<ScaffoldState>> {
  DrawerStateNotifier() : super(GlobalKey<ScaffoldState>());
}

final drawerKeyNotifier =
    StateNotifierProvider<DrawerStateNotifier, GlobalKey<ScaffoldState>>(
        (ref) => DrawerStateNotifier());
