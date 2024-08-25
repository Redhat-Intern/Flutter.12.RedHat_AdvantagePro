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
    // Build a StreamBuilder to listen to connectivity changes
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, connectivitySnapshot) {
        // Check if connectivity data is available
        if (connectivitySnapshot.hasData) {
          // Determine if the device is connected to the internet (mobile or wifi)
          bool isConnected =
              connectivitySnapshot.data!.contains(ConnectivityResult.mobile) ||
                  connectivitySnapshot.data!.contains(ConnectivityResult.wifi);

          if (isConnected) {
            // If connected, listen to authentication state changes
            return StreamBuilder<User?>(
              stream: AuthFB().authStateChanges,
              builder: (context, authSnapshot) {
                // While waiting for authentication state, show the loading page
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                }
                // If user data is available (logged in), push user data and navigate to the main app
                else if (authSnapshot.hasData) {
                  pushUserData(
                      ref:
                          ref); // Push user data to the server or perform related actions
                  return const Navigation();
                }
                // If no user data (not logged in), show the authentication page
                else {
                  return const MainAuthPage();
                }
              },
            );
          } else {
            // If not connected to the internet, show the no internet page
            return const NoInternet();
          }
        } else {
          // If connectivity data is not available yet, show the loading page
          return const LoadingPage();
        }
      },
    );
  }
}
