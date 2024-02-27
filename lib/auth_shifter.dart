import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';

import 'functions/firebase_auth.dart';

import 'functions/update/push_userdata.dart';
import 'layout/navigation.dart';
import 'layout/auth.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: AuthFB().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          pushUserData(ref: ref);
          return const Navigation();
        } else {
          return const MainAuthPage();
        }
      },
    );
  }
}
