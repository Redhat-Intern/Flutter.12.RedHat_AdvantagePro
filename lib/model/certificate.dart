import 'dart:io';

import 'course_data.dart';

class CertificateData {
  String name;
  File cousePDF;
  String description;
  String imageURL;
  int courseDataLength;
  List<CourseData> courseDataList;

  CertificateData({
    required this.name,
    required this.courseDataList,
    required this.cousePDF,
    required this.description,
    required this.imageURL,
    required this.courseDataLength,
  });

  factory CertificateData.empty() {
    return CertificateData(
      name: '',
      courseDataList: [],
      cousePDF: File(''),
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
    File? cousePDF,
    String? description,
    String? imageURL,
    int? courseDataLength,
    List<CourseData>? courseDataList,
  }) {
    return CertificateData(
      name: name ?? this.name,
      courseDataList: courseDataList ?? this.courseDataList,
      cousePDF: cousePDF ?? this.cousePDF,
      description: description ?? this.description,
      imageURL: imageURL ?? this.imageURL,
      courseDataLength: courseDataLength ?? this.courseDataLength,
    );
  }
}
