import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Stream<Map<int, String>> addStaff({
  required Map<File, String> photo,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneNoController,
  required TextEditingController experienceController,
  required List<Map<File, Map<String, dynamic>>> certificates,
}) async* {
  String name = nameController.text;
  String email = emailController.text;
  String phoneNo = phoneNoController.text;
  String experience = experienceController.text;

  Reference storageRef = FirebaseStorage.instance.ref();

  String photoURL =
      await uploadPhoto(ref: storageRef, photo: photo, email: email);
  yield {1: photoURL};

  List<String> certificatesURL = await uploadCertificates(
      ref: storageRef, certificates: certificates, email: email);
  yield {2: "uploaded certificates"};

  Map<String, dynamic> staffData = {
    "name": name,
    "photo": photoURL,
    "phoneNo": phoneNo,
    "experience": experience,
    "certificates": certificatesURL,
  };

  FirebaseFirestore.instance.collection("staffs").doc(email).set(staffData);
  yield {3: "Uploaded Data to firebase"};
}

Future<String> uploadPhoto(
    {required Reference ref,
    required Map<File, String> photo,
    required String email}) async {
  File photoFile = photo.keys.first;
  String photoName = photo.values.first;
  String path = "staff/$email/photo/$photoName";
  UploadTask uploadTask = ref.child(path).putFile(photoFile);
  TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
  String url = await onCompleted.ref.getDownloadURL();
  return url;
}

Future<List<String>> uploadCertificates(
    {required List<Map<File, Map<String, dynamic>>> certificates,
    required String email,
    required Reference ref}) async {
  String path = "staff/$email/certificates";
  List<String> downloadableURL = [];

  for (var certificate in certificates) {
    File file = certificate.keys.first;
    String fileName =
        certificates[certificates.indexOf(certificate)][file]?["name"];
    UploadTask fileUploadTask = ref.child("$path/$fileName").putFile(file);
    TaskSnapshot onCompleted = await fileUploadTask.whenComplete(() {});
    String url = await onCompleted.ref.getDownloadURL();
    // url
    downloadableURL.add(url);

    fileUploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print(progress);
          break;
        case TaskState.paused:
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
        case TaskState.success:
          break;
      }
    });
  }
  return downloadableURL;
}
