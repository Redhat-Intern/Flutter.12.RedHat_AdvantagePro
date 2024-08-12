import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> checkIdMatch(String id) async {
  QuerySnapshot<Map<String, dynamic>> staffList = await FirebaseFirestore
      .instance
      .collection("users")
      .where("userRole", whereIn: ["staff", "admin"]).get();

  for (var value in staffList.docs) {
    if (value.data()["id"].toLowerCase() == id.toLowerCase()) {
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
  required List<Map<File, Map<String, dynamic>>> courses,
}) async* {
  Reference storageRef = FirebaseStorage.instance.ref();

  String photoURL =
      await uploadPhoto(ref: storageRef, photo: photo, email: email);
  yield {1: staffId};

  Map<String, Map<String, dynamic>> coursesURL =
      await uploadCourses(ref: storageRef, courses: courses, email: email);
  yield {2: "Uploading Data to firebase"};

  Map<String, dynamic> staffData = {
    "id": staffId,
    "email": email,
    "name": name,
    "imagePath": photoURL,
    "userRole": isAdmin ? "admin" : "staff",
    "phoneNo": phoneNo,
    "courses": coursesURL,
  };

  FirebaseFirestore.instance.collection("requests").doc(email).set(staffData);
  yield {3: "Completed"};
}

Future<String> uploadPhoto(
    {required Reference ref,
    required Map<File, String> photo,
    required String email,
    String? collName}) async {
  File photoFile = photo.keys.first;
  String photoName = photo.values.first;
  String path = "staff/${collName ?? email}/photo/$photoName";
  UploadTask uploadTask = ref.child(path).putFile(photoFile);
  TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
  String url = await onCompleted.ref.getDownloadURL();
  return url;
}

Future<Map<String, Map<String, dynamic>>> uploadCourses(
    {required List<Map<File, Map<String, dynamic>>> courses,
    required String email,
    required Reference ref}) async {
  String path = "staff/$email/courses";
  Map<String, Map<String, dynamic>> downloadableURL = {};

  for (var course in courses) {
    File file = course.keys.first;
    String fileName = courses[courses.indexOf(course)][file]?["name"];
    UploadTask fileUploadTask = ref.child("$path/$fileName").putFile(file);
    TaskSnapshot onCompleted = await fileUploadTask.whenComplete(() {});
    String url = await onCompleted.ref.getDownloadURL();
    // url
    downloadableURL.addAll({
      url: {
        "name": fileName.split(".").first,
        "extension": fileName.split(".").last,
        "size": courses[courses.indexOf(course)][file]?["size"]
      }
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
