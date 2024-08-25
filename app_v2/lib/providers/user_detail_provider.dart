import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';
import '../utilities/static_data.dart';
import 'app_state_provider.dart';

class UserDetailNotifier extends StateNotifier<UserModel> {
  UserDetailNotifier(this.ref) : super(UserModel.empty);
  final Ref ref;

  void addUserData(UserModel userModel) {
    state = userModel;
  }

  void changeRole({required UserRole role}) {
    state = state.copyWith(userRole: role);
  }

  void clearData() {
    state = UserModel.empty;
    ref.read(appStateProvider.notifier).setUserExists(false);
  }
}

final userDataProvider = StateNotifierProvider<UserDetailNotifier, UserModel>(
    (ref) => UserDetailNotifier(ref));
