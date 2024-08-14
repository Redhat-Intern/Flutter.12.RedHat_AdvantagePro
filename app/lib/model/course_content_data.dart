import 'dart:io';

class CourseContentData {
  String title;
  String topics;
  Map<File, Map<String, dynamic>> files;

  CourseContentData({
    required this.title,
    required this.topics,
    required this.files,
  });

  @override
  String toString() {
    return 'CourseData{title: $title, topics: $topics, files: $files}';
  }
}

class CourseContentDataUpload {
  String title;
  String topics;
  Map<String, Map<String, dynamic>> files;

  CourseContentDataUpload({
    required this.title,
    required this.topics,
    required this.files,
  });
}
