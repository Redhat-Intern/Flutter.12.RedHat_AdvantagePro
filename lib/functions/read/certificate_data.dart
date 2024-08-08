import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/course_data.dart';
import '../../providers/certificate_data_provider.dart';

class CertificateService {
  final WidgetRef ref;

  CertificateService({required this.ref});

  Future<File?> downloadFile(String url, String fileName) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$fileName';
      final file = await File(filePath).writeAsBytes(response.data);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<Map<File, Map<String, dynamic>>> getFileMap(
      Map<String, dynamic> fileData) async {
    Map<File, Map<String, dynamic>> fileMap = {};

    for (MapEntry<String, Map<dynamic, dynamic>> entry
        in fileData.entries.map((e) => MapEntry(e.key, Map.from(e.value)))) {
      File? file = await downloadFile(entry.key, entry.value["name"]);
      if (file != null) {
        fileMap[file] = Map<String, dynamic>.from(entry.value);
      } else {
        print("******* DATA NOT FOUND ******");
      }
    }

    return fileMap;
  }

  void readCertificateData(
      {String? batchName,
      required String certificateName,
      required bool isFromBatch}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot = isFromBatch
        ? FirebaseFirestore.instance
            .collection("certificates")
            .doc(certificateName)
            .collection("instances")
            .doc(batchName)
            .snapshots()
        : FirebaseFirestore.instance
            .collection("certificates")
            .doc(certificateName)
            .snapshots();

    snapshot.listen((event) async {
      Map<String, dynamic> certificateData = event.data()!;
      String name = certificateData["name"];
      String imageURL = certificateData["image"];
      String description = certificateData["description"];

      // Update basic information
      ref.read(certificateDataProvider.notifier).updateName(newName: name);
      ref
          .read(certificateDataProvider.notifier)
          .updateImageURL(imageURL: imageURL);
      ref
          .read(certificateDataProvider.notifier)
          .updateDescription(description: description);

      // Update course data length
      ref.read(certificateDataProvider.notifier).updateCourseDataLength(
          courseDataLength: Map.from(certificateData["courseContent"]).length);

      // Download the course PDF
      File? coursePDF = await downloadFile(
          certificateData["coursePDF"], "${name}_coursePDF.pdf");
      if (coursePDF != null) {
        ref
            .read(certificateDataProvider.notifier)
            .updateCoursePDF(coursePDF: coursePDF);
      }

      // Process course content
      for (MapEntry courseDataEntry
          in Map.from(certificateData["courseContent"]).entries) {
        Map<File, Map<String, dynamic>> courseFiles =
            await getFileMap(courseDataEntry.value["files"]);

        CourseData courseData = CourseData(
            title: courseDataEntry.value["title"],
            topics: courseDataEntry.value["topics"],
            files: courseFiles);

        ref
            .read(certificateDataProvider.notifier)
            .addOrUpdateCourseData(courseData: courseData);
      }
    });
  }
}
