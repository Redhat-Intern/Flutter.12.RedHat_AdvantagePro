import 'dart:io';

import 'course_data.dart';

class CertificateData {
  String name;
  File coursePDF;
  String description;
  String imageURL;
  int courseDataLength;
  List<CourseData> courseDataList;

  CertificateData({
    required this.name,
    required this.courseDataList,
    required this.coursePDF,
    required this.description,
    required this.imageURL,
    required this.courseDataLength,
  });

  factory CertificateData.empty() {
    return CertificateData(
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

  CertificateData copyWith({
    String? name,
    File? coursePDF,
    String? description,
    String? imageURL,
    int? courseDataLength,
    List<CourseData>? courseDataList,
  }) {
    return CertificateData(
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
    return 'CertificateData{name: $name, coursePDF: ${coursePDF.path}, description: $description, imageURL: $imageURL, courseDataLength: $courseDataLength, courseDataList: $courseDataList}';
  }
}
