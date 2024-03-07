import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/course_data.dart';
import '../../providers/certificate_data_provider.dart';

readCertificateData(
    {required String batchName,
    required String certificateName,
    required WidgetRef ref}) {
  Future<File?> downloadFile(String path, String name) async {
    try {
      final response = await Dio()
          .get(path, options: Options(responseType: ResponseType.bytes));

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$name';
      final file = await File(filePath).writeAsBytes(response.data);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<Map<File, Map<String, dynamic>>> getFileMap(
      {required Map<String, dynamic> fileData}) async {
    Map<File, Map<String, dynamic>> fileMap = {};

    for (MapEntry<String, Map<dynamic, dynamic>> e in fileData.entries.map(
        (MapEntry<String, dynamic> e) => MapEntry(e.key, Map.from(e.value)))) {
      File? file = await downloadFile(e.key, e.value["name"]);
      if (file != null) {
        fileMap.addAll({file: Map<String, dynamic>.from(e.value)});
      }
    }

    return fileMap;
  }

  FirebaseFirestore.instance
      .collection("certificates")
      .doc(certificateName)
      .collection("instances")
      .doc(batchName)
      .snapshots()
      .listen(
    (event) async {
      Map<String, dynamic> certificateData = event.data()!;
      String name = certificateData["name"];
      String imageURL = certificateData["image"];
      String description = certificateData["description"];

      Future(() {
        ref.read(certificateDataProvider.notifier).updateName(newName: name);
        ref
            .read(certificateDataProvider.notifier)
            .updateImageURL(imageURL: imageURL);
        ref
            .read(certificateDataProvider.notifier)
            .updateDescription(description: description);
      });

      File? coursePDF = await downloadFile(
          certificateData["coursePDF"], "${name}_coursePDF.pdf");

      Future(() {
        ref
            .read(certificateDataProvider.notifier)
            .updateCoursePDF(coursePDF: coursePDF!);
      });

      // List<CourseData> courseDataList = [];
      Future(() {
        ref.read(certificateDataProvider.notifier).updateCourseDataLength(
            courseDataLength:
                Map.from(certificateData["courseContent"]).length);
      });

      for (MapEntry courseData
          in Map.from(certificateData["courseContent"]).entries) {
        Map<File, Map<String, dynamic>> courseFiles =
            await getFileMap(fileData: courseData.value["files"]);

        CourseData data = CourseData(
            title: courseData.value["title"],
            topics: courseData.value["topics"],
            files: courseFiles);

        Future(() {
          ref
              .read(certificateDataProvider.notifier)
              .updateCourseData(courseData: data);
        });

        // courseDataList.add(data);
      }
    },
  );
}
