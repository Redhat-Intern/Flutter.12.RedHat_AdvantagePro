import 'package:intl/intl.dart';

import 'student.dart';
import 'user.dart';

class Batch {
  DateTime creationTime;
  String name;
  Map<String, dynamic> courseData;
  List<String> dates;
  List<UserModel> staffs;
  List<Student> students;

  Batch({
    required this.creationTime,
    required this.name,
    required this.courseData,
    required this.dates,
    required this.staffs,
    required this.students,
  });

  factory Batch.empty() {
    return Batch(
      creationTime: DateTime.now(),
      name: '',
      courseData: {},
      dates: [],
      staffs: [],
      students: [],
    );
  }

  Batch copyWith({
    DateTime? creationTime,
    String? name,
    Map<String, dynamic>? courseData,
    List<String>? dates,
    List<UserModel>? staffs,
    UserModel? adminStaff,
    List<Student>? students,
  }) {
    return Batch(
      creationTime: creationTime ?? this.creationTime,
      name: name ?? this.name,
      courseData: courseData ?? this.courseData,
      dates: dates ?? this.dates,
      staffs: staffs ?? this.staffs,
      students: students ?? this.students,
    );
  }

  bool isNotEmpty({required bool needStudentCheck}) {
    return name.isNotEmpty &&
        name != "" &&
        courseData.isNotEmpty &&
        dates.isNotEmpty &&
        staffs.isNotEmpty &&
        (needStudentCheck ? students.isNotEmpty : true);
  }

  Map<String, dynamic> toMap() {
    return {
      'time': DateFormat("dd-MM-yyyy").format(creationTime),
      'name': name.toUpperCase(),
      'courseID': courseData["name"],
      'dates': dates,
      'staffs': staffs.map((data) => {data.staffId: data.email}),
      'students': students.isNotEmpty
          ? students.map((student) => {student.registrationID: student.email})
          : {},
    };
  }
}
