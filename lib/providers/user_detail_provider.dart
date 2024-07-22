// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../utilities/static_data.dart';

class UserDetailNotifier extends StateNotifier<UserModel> {
  UserDetailNotifier() : super(UserModel.empty);

  void addUserData(UserModel userModel) {
    state = userModel;

    SharedPreferences.getInstance().then((value) {
      value.setString("role", userModel.userRole!.name);
    });
  }

  void changeRole({required UserRole role}) {
    state = state.copyWith(userRole: role);

    SharedPreferences.getInstance().then((value) {
      value.setString("role", role.name);
    });
  }
}

final userDataProvider = StateNotifierProvider<UserDetailNotifier, UserModel>(
    (ref) => UserDetailNotifier());
