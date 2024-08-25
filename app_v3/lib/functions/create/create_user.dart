import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../model/user.dart';
import '../firebase_auth.dart';
import 'add_staff.dart';

Future createUser({
  required WidgetRef ref,
  required String email,
  required String password,
  required UserModel generatedData,
  required BuildContext context,
  required Map<File, String> photo,
}) async {
  AuthFB()
      .createUserWithEmailAndPassword(
    email: email,
    password: password,
  )
      .then((value) async {
    if (photo.isNotEmpty) {
      Reference storageRef = FirebaseStorage.instance.ref();
      String imagePath = await uploadPhoto(
          ref: storageRef, photo: photo, email: email, collName: "student");
      generatedData = generatedData.copyWith(imagePath: imagePath);
    }

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
          text: error.toString(),
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  });
}
