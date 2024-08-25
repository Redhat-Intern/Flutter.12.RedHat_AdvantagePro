import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../functions/cache.dart';
import '../functions/firebase_auth.dart';
import '../model/app_state.dart';
import '../model/user.dart';
import '../utilities/console_logger.dart';
import '../utilities/static_data.dart';
import 'user_detail_provider.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  final Ref ref;
  AppStateNotifier({required this.ref}) : super(AppState()) {
    _initialize();
    _monitorConnectivity();
    _monitorServerMaintenance();
  }

  void setFirstLoad({required bool state}) {
    this.state = this.state.copyWith(isFirstRun: state);
  }

  Future<void> _initialize() async {
    ConsoleLogger.processStart("Initialization Status");

    state = state.copyWith(isLoading: true);

    // Initial Setup
    CacheManager cacheManager = CacheManager();
    bool isFirstRunValue = await cacheManager.getBoolean(isFirstRun) ?? true;

    if (!isFirstRunValue) {
      state = state.copyWith(splashPage: true, isLoading: false);
      _monitorAuthState();
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(splashPage: false);
    } else {
      state = state.copyWith(isFirstRun: true, isLoading: false);
    }

    ConsoleLogger.processComplete("Initialization Status");
  }

  void _monitorAuthState() {
    String? email = AuthFB().currentUser?.email.toString();
    if (email != null) {
      FirebaseFirestore.instance.collection('users').snapshots().listen((data) {
        state = state.copyWith(isLoading: true);
        if (data.docs.isNotEmpty) {
          QueryDocumentSnapshot<Map<String, dynamic>>? querySnapshot = data.docs
              .where((data) => data.id.toLowerCase() == email.toLowerCase())
              .firstOrNull;
          if (querySnapshot != null) {
            Map<String, dynamic> docData = querySnapshot.data();
            UserModel userModel = UserModel.fromJson(docData);
            ConsoleLogger.message("message");
            ref.read(userDataProvider.notifier).addUserData(userModel);
            state = state.copyWith(userExists: true);
          } else {
            state = state.copyWith(isUserRemoved: true);
          }
          state = state.copyWith(isLoading: false);
        } else {
          ConsoleLogger.message("UserData loading failed : Firebase Fault");
        }
      });
    } else {
      ConsoleLogger.message("User is not logged in");
      state = state.copyWith(userExists: false);
    }
  }

  void completeOnboarding() {
    state = state.copyWith(isFirstRun: false);
    ConsoleLogger.processComplete("Onboarding Screen Completed");
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isFirstRun', false);
    });
  }

  void setUserExists(bool? value) {
    state = state.copyWith(userExists: value ?? true);
  }

  void setError(String message) {
    ConsoleLogger.error(message);
    state = state.copyWith(hasError: true, errorMessage: message);
  }

  void _monitorConnectivity() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
      ConsoleLogger.fetchedData("Connection result: $result");
      ConsoleLogger.fetchedData("Connection Status: $isConnected");
      state = state.copyWith(isConnected: isConnected);
    });
  }

  void _monitorServerMaintenance() {
    FirebaseFirestore.instance
        .collection('maintenance')
        .doc('server')
        .snapshots()
        .listen((event) {
      if (event.exists && event.data() != null) {
        bool serverUnderMaintenance = event.data()!["value"] as bool == true;
        ConsoleLogger.fetchedData(
            "Server Maintenance Status: $serverUnderMaintenance");
        state = state.copyWith(serverUnderMaintenance: serverUnderMaintenance);
      }
    });
  }
}

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(ref: ref);
});
