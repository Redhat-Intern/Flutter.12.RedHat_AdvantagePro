import 'package:intl/intl.dart';

import 'student.dart';

class Batch {
  DateTime creationTime;
  String name;
  String certificateName;
  String certificateImg;
  List<String> dates;
  List<String> staffs;
  String adminStaff;
  List<Student> students;

  Batch({
    required this.creationTime,
    required this.name,
    required this.certificateName,
    required this.certificateImg,
    required this.dates,
    required this.staffs,
    required this.adminStaff,
    required this.students,
  });

  factory Batch.empty() {
    return Batch(
      creationTime: DateTime.now(),
      name: '',
      certificateName: '',
      certificateImg: '',
      adminStaff: '',
      dates: [],
      staffs: [],
      students: [],
    );
  }

  Batch copyWith({
    DateTime? creationTime,
    String? name,
    String? certificateName,
    String? certificateImg,
    List<String>? dates,
    List<String>? staffs,
    String? adminStaff,
    List<Student>? students,
  }) {
    return Batch(
      creationTime: creationTime ?? this.creationTime,
      name: name ?? this.name,
      certificateName: certificateName ?? this.certificateName,
      certificateImg: certificateImg ?? this.certificateImg,
      dates: dates ?? this.dates,
      staffs: staffs ?? this.staffs,
      adminStaff: adminStaff ?? this.adminStaff,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': DateFormat("dd-MM-yyyy").format(creationTime),
      'name': name,
      'certificateName': certificateName,
      'certificateImg': certificateImg,
      'dates': dates,
      'staffs': staffs,
      "admin": adminStaff,
      'students': students.map((student) => {
            "${name}STU${students.indexOf(student).toString().padLeft(3, '0')}":
                student.email
          }),
    };
  }
}
