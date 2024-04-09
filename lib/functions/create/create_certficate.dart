import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../model/course_data.dart';

Stream<Map<int, String>> createCertificate({
  required Map<File, String> image,
  required Map<File, String> pdf,
  required TextEditingController nameController,
  required TextEditingController discriptionController,
  required Map<int, CourseData> courseContent,
}) async* {
  String name = nameController.text;
  String disciption = discriptionController.text;

  Reference storageRef = FirebaseStorage.instance.ref();
  String commonPath = "certificate/$name";

  String imageURL =
      await uploadImage(ref: storageRef, image: image, commonPath: commonPath);
  yield {1: imageURL};

  String coursePDFURL =
      await uploadPDF(ref: storageRef, pdf: pdf, commonPath: commonPath);
  yield {2: coursePDFURL};

  Map<int, CourseDataUpload> contentMap = await uploadCourseContent(
      ref: storageRef, courseContent: courseContent, commonPath: commonPath);

  yield {3: "uploaded certificates"};

  Map<String, dynamic> certificateData = {
    "name": name,
    "description": disciption,
    "image": imageURL,
    "coursePDF": coursePDFURL,
    "courseContent": {
      ...contentMap.map((key, value) => MapEntry(key.toString(), {
            "title": value.title.toString(),
            "topics": value.topics.toString(),
            "files": value.files
          })),
    },
  };

  FirebaseFirestore.instance
      .collection("certificates")
      .doc(name)
      .set(certificateData);
  yield {4: "Uploaded Data to firebase"};
}

Future<String> uploadImage({
  required Reference ref,
  required Map<File, String> image,
  required String commonPath,
}) async {
  File imageFile = image.keys.first;
  String path = "$commonPath/image";
  UploadTask uploadTask = ref.child(path).putFile(imageFile);
  TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
  String url = await onCompleted.ref.getDownloadURL();
  return url;
}

Future<String> uploadPDF({
  required Reference ref,
  required Map<File, String> pdf,
  required String commonPath,
}) async {
  File pdfFile = pdf.keys.first;
  String path = "$commonPath/pdf";
  UploadTask uploadTask = ref.child(path).putFile(pdfFile);
  TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
  String url = await onCompleted.ref.getDownloadURL();
  return url;
}

Future<Map<int, CourseDataUpload>> uploadCourseContent({
  required Reference ref,
  required String commonPath,
  required Map<int, CourseData> courseContent,
}) async {
  String path = "$commonPath/courseData";
  Map<int, CourseDataUpload> contentMap = {};

  for (MapEntry<int, CourseData> i in courseContent.entries) {
    int key = i.key;
    CourseData value = i.value;
    Map<String, Map<String, dynamic>> filesData = await uploadFiles(
      files: value.files,
      path: "$path/$key",
      ref: ref,
    );

    MapEntry<int, CourseDataUpload> currentContentMapData = MapEntry(
      key,
      CourseDataUpload(
        title: value.title,
        topics: value.topics,
        files: filesData,
      ),
    );

    contentMap[currentContentMapData.key] = currentContentMapData.value;
  }
  return contentMap;
}

Future<Map<String, Map<String, dynamic>>> uploadFiles({
  required Map<File, Map<String, dynamic>> files,
  required String path,
  required Reference ref,
}) async {
  Map<String, Map<String, dynamic>> filesMap = {};

  for (var fileData in files.entries) {
    File file = fileData.key;
    String fileName = fileData.value["name"];

    UploadTask fileUploadTask = ref.child("$path/$fileName").putFile(file);
    TaskSnapshot onCompleted = await fileUploadTask.whenComplete(() {});
    String url = await onCompleted.ref.getDownloadURL();

    // url
    MapEntry<String, Map<String, dynamic>> fileMap =
        MapEntry(url.toString(), fileData.value);
    filesMap[fileMap.key] = fileMap.value;
  }

  return filesMap;
}
