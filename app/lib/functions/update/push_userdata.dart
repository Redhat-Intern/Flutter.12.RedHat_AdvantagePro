import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../firebase_auth.dart';

void pushUserData({required WidgetRef ref}) async {
  String? email = AuthFB().currentUser?.email.toString();

  if (email != null) {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (snapshot.exists && snapshot.data() != null) {
      UserModel userModel = UserModel.fromJson(snapshot.data()!);
      ref.read(userDataProvider.notifier).addUserData(userModel);
    } else {
      ref
          .read(userDataProvider.notifier)
          .setUserNotFound(value: "UserData not found");
    }
  }
}
