// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/static_data.dart';

class UserRoleNotifier extends StateNotifier<UserRole?> {
  UserRoleNotifier() : super(null);

  void setUserRole(UserRole? userRole) {
    state = userRole;
  }
}

final userRoleProvider =
    StateNotifierProvider<UserRoleNotifier, UserRole?>(
        (ref) => UserRoleNotifier());
