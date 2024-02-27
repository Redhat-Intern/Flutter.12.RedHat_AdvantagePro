import 'package:intl/intl.dart';

import 'student.dart';

class Batch {
  DateTime creationTime;
  String name;
  Map<String, dynamic> certificateData;
  List<String> dates;
  List<Map<String, dynamic>> staffs;
  Map<String, dynamic> adminStaff;
  List<Student> students;

  Batch({
    required this.creationTime,
    required this.name,
    required this.certificateData,
    required this.dates,
    required this.staffs,
    required this.adminStaff,
    required this.students,
  });

  factory Batch.empty() {
    return Batch(
      creationTime: DateTime.now(),
      name: '',
      certificateData: {},
      adminStaff: {},
      dates: [],
      staffs: [],
      students: [],
    );
  }

  Batch copyWith({
    DateTime? creationTime,
    String? name,
    Map<String, dynamic>? certificateData,
    List<String>? dates,
    List<Map<String, dynamic>>? staffs,
    Map<String, dynamic>? adminStaff,
    List<Student>? students,
  }) {
    return Batch(
      creationTime: creationTime ?? this.creationTime,
      name: name ?? this.name,
      certificateData: certificateData ?? this.certificateData,
      dates: dates ?? this.dates,
      staffs: staffs ?? this.staffs,
      adminStaff: adminStaff ?? this.adminStaff,
      students: students ?? this.students,
    );
  }

  bool isEmpty() {
    return name.isEmpty &&
        certificateData.isEmpty &&
        dates.isEmpty &&
        staffs.isEmpty &&
        adminStaff.isEmpty &&
        students.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'time': DateFormat("dd-MM-yyyy").format(creationTime),
      'name': name,
      'certificateID': certificateData["name"],
      'dates': dates,
      'staffs': staffs,
      "admin": adminStaff,
      'students': students.map((student) => {
            "${name}STU${(students.indexOf(student)+1).toString().padLeft(3, '0')}":
                student.email
          }),
    };
  }
}
