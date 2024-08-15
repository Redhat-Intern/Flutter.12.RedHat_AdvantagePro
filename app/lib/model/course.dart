import 'dart:io';

import 'course_content_data.dart';

class CourseData {
  String name;
  File coursePDF;
  String description;
  String imageURL;
  int courseDataLength;
  List<CourseContentData> courseDataList;

  CourseData({
    required this.name,
    required this.courseDataList,
    required this.coursePDF,
    required this.description,
    required this.imageURL,
    required this.courseDataLength,
  });

  factory CourseData.empty() {
    return CourseData(
      name: '',
      courseDataList: [],
      coursePDF: File(''),
      description: '',
      imageURL: '',
      courseDataLength: 0,
    );
  }

  bool isEmpty() {
    return name.isEmpty &&
        courseDataList.isEmpty &&
        description.isEmpty &&
        imageURL.isEmpty &&
        courseDataLength == 0;
  }

  CourseData copyWith({
    String? name,
    File? coursePDF,
    String? description,
    String? imageURL,
    int? courseDataLength,
    List<CourseContentData>? courseDataList,
  }) {
    return CourseData(
      name: name ?? this.name,
      courseDataList: courseDataList ?? this.courseDataList,
      coursePDF: coursePDF ?? this.coursePDF,
      description: description ?? this.description,
      imageURL: imageURL ?? this.imageURL,
      courseDataLength: courseDataLength ?? this.courseDataLength,
    );
  }

  @override
  String toString() {
    return 'CourseData{name: $name, coursePDF: ${coursePDF.path}, description: $description, imageURL: $imageURL, courseDataLength: $courseDataLength, courseDataList: $courseDataList}';
  }
}
