import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/course_content_data.dart';
import '../../providers/course_data_provider.dart';
import '../../utilities/console_logger.dart';

final courseServiceProvider = Provider<CourseService>((ref) {
  return CourseService(ref: ref);
});

class CourseService {
  final Ref ref;

  CourseService({required this.ref});

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
        ConsoleLogger.error(
          "******* DATA NOT FOUND ******",
        );
      }
    }

    return fileMap;
  }

  void readCourseData(
      {String? batchName,
      required String courseName,
      required bool isFromBatch}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot = isFromBatch
        ? FirebaseFirestore.instance
            .collection("courses")
            .doc(courseName)
            .collection("instances")
            .doc(batchName)
            .snapshots()
        : FirebaseFirestore.instance
            .collection("courses")
            .doc(courseName)
            .snapshots();

    snapshot.listen((event) async {
      Map<String, dynamic> courseData = event.data()!;
      String name = courseData["name"];
      String imageURL = courseData["image"];
      String description = courseData["description"];

      // Update basic information
      ref.read(courseDataProvider.notifier).updateName(newName: name);
      ref.read(courseDataProvider.notifier).updateImageURL(imageURL: imageURL);
      ref
          .read(courseDataProvider.notifier)
          .updateDescription(description: description);

      // Update course data length
      ref.read(courseDataProvider.notifier).updateCourseDataLength(
          courseDataLength: Map.from(courseData["courseContent"]).length);

      // Download the course PDF
      File? coursePDF =
          await downloadFile(courseData["coursePDF"], "${name}_coursePDF.pdf");
      if (coursePDF != null) {
        ref
            .read(courseDataProvider.notifier)
            .updateCoursePDF(coursePDF: coursePDF);
      }

      // Process course content
      for (MapEntry courseDataEntry
          in Map.from(courseData["courseContent"]).entries) {
        Map<File, Map<String, dynamic>> courseFiles =
            await getFileMap(courseDataEntry.value["files"]);

        CourseContentData courseData = CourseContentData(
            title: courseDataEntry.value["title"],
            topics: courseDataEntry.value["topics"],
            files: courseFiles);
        ref
            .read(courseDataProvider.notifier)
            .addOrUpdateCourseData(courseData: courseData);
      }
    });
  }
}
