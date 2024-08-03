import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> checkIdMatch(String id) async {
  QuerySnapshot<Map<String, dynamic>> staffList =
      await FirebaseFirestore.instance.collection("staffs").get();
  for (var value in staffList.docs) {
    if (value.id.toLowerCase() == id.toLowerCase()) {
      return true;
    }
  }
  return false;
}

Stream<Map<int, String>> addStaff({
  required Map<File, String> photo,
  required String name,
  required String email,
  required String phoneNo,
  required String staffId,
  required bool isAdmin,
  required List<Map<File, Map<String, dynamic>>> certificates,
}) async* {
  Reference storageRef = FirebaseStorage.instance.ref();

  String photoURL =
      await uploadPhoto(ref: storageRef, photo: photo, email: email);
  yield {1: staffId};

  Map<String, Map<String, dynamic>> certificatesURL = await uploadCertificates(
      ref: storageRef, certificates: certificates, email: email);
  yield {2: "uploaded certificates"};

  Map<String, dynamic> staffData = {
    "id": staffId,
    "email": email,
    "name": name,
    "imagePath": photoURL,
    "userRole": isAdmin ? "admin" : "staff",
    "phoneNo": phoneNo,
    "certificates": certificatesURL,
  };

  FirebaseFirestore.instance.collection("requests").doc(email).set(staffData);
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

Future<Map<String, Map<String, dynamic>>> uploadCertificates(
    {required List<Map<File, Map<String, dynamic>>> certificates,
    required String email,
    required Reference ref}) async {
  String path = "staff/$email/certificates";
  Map<String, Map<String, dynamic>> downloadableURL = {};

  for (var certificate in certificates) {
    File file = certificate.keys.first;
    String fileName =
        certificates[certificates.indexOf(certificate)][file]?["name"];
    UploadTask fileUploadTask = ref.child("$path/$fileName").putFile(file);
    TaskSnapshot onCompleted = await fileUploadTask.whenComplete(() {});
    String url = await onCompleted.ref.getDownloadURL();
    // url
    downloadableURL.addAll({
      url: {"name": fileName, "extension": fileName.split(".").last}
    });

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
