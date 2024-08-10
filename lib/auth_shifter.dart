import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'functions/firebase_auth.dart';

import 'functions/update/push_userdata.dart';
import 'layout/loading_page.dart';
import 'layout/navigation.dart';
import 'layout/auth.dart';
import 'layout/no_internet.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connectionState) {
          if (connectionState.hasData) {
            bool isConnected =
                connectionState.data!.contains(ConnectivityResult.mobile) ||
                    connectionState.data!.contains(ConnectivityResult.wifi);
            if (isConnected) {
              return StreamBuilder(
                stream: AuthFB().authStateChanges,
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  } else if (snapshot.hasData) {
                    pushUserData(ref: ref);
                    return const Navigation();
                  } else {
                    return const MainAuthPage();
                  }
                },
              );
            } else {
              return const NoInternet();
            }
          } else {
            return const LoadingPage();
          }
        });
  }
}
