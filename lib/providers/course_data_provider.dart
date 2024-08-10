import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';
import '../model/course_content_data.dart';

class CourseDataNotifier extends StateNotifier<CourseData> {
  CourseDataNotifier() : super(CourseData.empty());

  void clearData() {
    state = CourseData.empty();
  }

  void updateName({required String newName}) {
    state = state.copyWith(name: newName);
  }

  void updateImageURL({required String imageURL}) {
    state = state.copyWith(imageURL: imageURL);
  }

  void updateCoursePDF({required File coursePDF}) {
    state = state.copyWith(coursePDF: coursePDF);
  }

  void updateCourseDataLength({required int courseDataLength}) {
    state = state.copyWith(courseDataLength: courseDataLength);
  }

  void updateDescription({required String description}) {
    state = state.copyWith(description: description);
  }

  void addOrUpdateCourseData({required CourseContentData courseData}) {
    List<CourseContentData> courseDataList = List.from(state.courseDataList);
    int index = courseDataList
        .indexWhere((element) => element.title == courseData.title);

    if (index != -1) {
      courseDataList[index] = courseData;
    } else {
      courseDataList.add(courseData);
    }

    state = state.copyWith(courseDataList: courseDataList);
  }

  void clearCourseData() {
    state = state.copyWith(courseDataList: []);
  }

  void updateData({required CourseData data}) {
    state = data;
  }

  void deleteCourse() async {
    await FirebaseFirestore.instance
        .collection("courses")
        .doc(state.name)
        .delete();
    clearData();
  }
}

final courseDataProvider =
    StateNotifierProvider<CourseDataNotifier, CourseData>(
        (ref) => CourseDataNotifier());
