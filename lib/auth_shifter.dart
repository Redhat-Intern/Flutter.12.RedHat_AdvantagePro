import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';

import 'firebase/firebase_auth.dart';
import 'layout/auth.dart';
import 'layout/navigation.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  void pushUserData({required WidgetRef ref}) {
    String email = AuthFB().currentUser!.email.toString();
    FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .snapshots()
        .listen((event) {
      Map<String, dynamic> userDataMap = {"email": email};
      for (var e in event.data()!.entries) {
        userDataMap.addAll({e.key: e.value});
      }
      ref.read(userDataProvider.notifier).addUserData(userDataMap);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: AuthFB().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          pushUserData(ref: ref);
          return Navigation();
        } else {
          return Auth();
        }
      },
    );
  }
}
