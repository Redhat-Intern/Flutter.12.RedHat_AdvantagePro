// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailNotifier extends StateNotifier<Map<String, dynamic>> {
  UserDetailNotifier() : super({"name": "", "role": ""});

  void addUserData(Map<String, dynamic> userData) {
    state = userData;
  }
}

final userDataNotifier =
    StateNotifierProvider<UserDetailNotifier, Map<String, dynamic>>(
        (ref) => UserDetailNotifier());
