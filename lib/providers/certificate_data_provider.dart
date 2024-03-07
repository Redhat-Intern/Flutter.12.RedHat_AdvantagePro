import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/certificate.dart';
import '../model/course_data.dart';

class CertificateDataNotifier extends StateNotifier<CertificateData> {
  CertificateDataNotifier() : super(CertificateData.empty());

  void clearData() {
    state = CertificateData.empty();
  }

  void updateName({required String newName}) {
    state = state.copyWith(name: newName);
  }

  void updateImageURL({required String imageURL}) {
    state = state.copyWith(imageURL: imageURL);
  }

  void updateCoursePDF({required File coursePDF}) {
    state = state.copyWith(cousePDF: coursePDF);
  }

  void updateCourseDataLength({required int courseDataLength}) {
    state = state.copyWith(courseDataLength: courseDataLength);
  }

  void updateDescription({required String description}) {
    state = state.copyWith(description: description);
  }

  void updateCourseData({required CourseData courseData}) {
    if (state.courseDataList
        .where((element) => element.title == courseData.title)
        .isEmpty) {
      List<CourseData> courseDataList = state.courseDataList;
      courseDataList.add(courseData);
      state = state.copyWith(courseDataList: courseDataList);
    }
  }

  void clearCourseData() {
    state = state.copyWith(courseDataList: []);
  }

  void updateData({required CertificateData data}) {
    state = data;
  }
}

final certificateDataProvider =
    StateNotifierProvider<CertificateDataNotifier, CertificateData>(
        (ref) => CertificateDataNotifier());
