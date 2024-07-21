import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../model/user.dart';
import '../firebase_auth.dart';

Future createUser({
  required WidgetRef ref,
  required String email,
  required String password,
  required UserModel generatedData,
  required BuildContext context,
}) async {
  AuthFB()
      .createUserWithEmailAndPassword(
    email: email,
    password: password,
  )
      .then((value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set(generatedData.toJson());
    await FirebaseFirestore.instance.collection("requests").doc(email).delete();

    Navigator.pop(context);
  }).catchError((error) {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: CustomText(
          text: error.message.toString(),
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  });
}
