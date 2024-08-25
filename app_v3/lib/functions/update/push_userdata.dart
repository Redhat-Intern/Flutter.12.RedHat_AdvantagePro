import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../firebase_auth.dart';

void pushUserData({required WidgetRef ref}) async {
  String? email = AuthFB().currentUser?.email.toString();

  if (email != null) {
    FirebaseFirestore.instance.collection('users').snapshots().listen((data) {
      if (data.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>>? querySnapshot = data.docs
            .where((data) => data.id.toLowerCase() == email.toLowerCase())
            .firstOrNull;
        if (querySnapshot != null) {
          Map<String, dynamic> docData = querySnapshot.data();
          UserModel userModel = UserModel.fromJson(docData);
          ref.read(userDataProvider.notifier).addUserData(userModel);
        }
      } else {
        ref
            .read(userDataProvider.notifier)
            .setUserNotFound(value: "UserData not found");
      }
    });
  }
}
