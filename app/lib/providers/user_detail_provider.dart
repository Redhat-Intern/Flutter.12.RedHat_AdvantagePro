// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../utilities/static_data.dart';

class UserDetailNotifier extends StateNotifier<MapEntry<UserModel, String?>> {
  UserDetailNotifier() : super(const MapEntry(UserModel.empty, null));

  void addUserData(UserModel userModel) {
    state = MapEntry(userModel, null);

    SharedPreferences.getInstance().then((value) {
      value.setString("role", userModel.userRole!.name);
    });
  }

  void changeRole({required UserRole role}) {
    state = MapEntry(state.key.copyWith(userRole: role), null);

    SharedPreferences.getInstance().then((value) {
      value.setString("role", role.name);
    });
  }

  void clearData() {
    state = const MapEntry(UserModel.empty, null);
  }

  void setUserNotFound({required String value}) {
    state = MapEntry(UserModel.empty, value);
  }
}

final userDataProvider =
    StateNotifierProvider<UserDetailNotifier, MapEntry<UserModel, String?>>(
        (ref) => UserDetailNotifier());
