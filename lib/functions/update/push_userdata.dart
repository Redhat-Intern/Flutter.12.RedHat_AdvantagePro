import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_detail_provider.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../firebase_auth.dart';

void pushUserData({required WidgetRef ref}) {
  String email = AuthFB().currentUser!.email.toString();

  UserRole? role = ref.watch(userRoleProvider);
  if (role == null) {
    SharedPreferences.getInstance().then((value) {
      Function setUserRole = ref.read(userRoleProvider.notifier).setUserRole;
      switch (value.getString("role")) {
        case "admin":
          setUserRole(UserRole.admin);
          break;
        case "staff":
          setUserRole(UserRole.staff);
          break;
        case "student":
          setUserRole(UserRole.student);
          break;
      }
    });
  } else {
    FirebaseFirestore.instance
        .collection('${role.name}s')
        .doc(email)
        .snapshots()
        .listen((event) {
      Map<String, dynamic> userDataMap = {
        "email": email,
        "role": role.name.toString()
      };
      for (var e in event.data()!.entries) {
        userDataMap.addAll({e.key: e.value});
      }
      ref.read(userDataProvider.notifier).addUserData(userDataMap);
    }).onError((obj) {
      debugPrint(obj.message);
    });
  }
}
