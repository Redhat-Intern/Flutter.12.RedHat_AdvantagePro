import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'class/batch.dart';
import 'class/student.dart';

class CreateBatchNotifier extends StateNotifier<Batch> {
  CreateBatchNotifier() : super(Batch.empty());

  void clearData() {
    state = Batch.empty();
  }

  void updateTime() {
    state = state.copyWith(creationTime: DateTime.now());
  }

  void updateName({required String newName}) {
    state = state.copyWith(name: newName);
  }

  void updateCertificate(
      {required Map newCertificateData}) {
    state = state.copyWith(
      certificateData: newCertificateData,
    );
  }

  void updateDates({required List<String> newDates}) {
    state = state.copyWith(dates: newDates);
  }

  void updateStaffs({required List<String> newStaffs}) {
    state = state.copyWith(staffs: newStaffs);
  }

  void updateAdminStaff({required String adminStaff}) {
    state = state.copyWith(adminStaff: adminStaff);
  }

  void addDataToSheet(List<List<String>> data) {
    state = state.copyWith(
      students: _processStudentData(data),
    );
  }

  List<Student> _processStudentData(List<List<String>> data) {
    Set<String> uniqueEmails = <String>{};
    List<Student> uniqueStudents = [];

    for (var row in data.sublist(1)) {
      String email = row[1];

      if (!uniqueEmails.contains(email)) {
        uniqueEmails.add(email);

        Student student = Student(
          name: row[0],
          email: row[1],
          phoneNo: row[2],
          occupation: StudentOcc.college.name.toLowerCase() ==
                  row[3].toString().toLowerCase()
              ? StudentOcc.college
              : StudentOcc.professional,
          occDetail: row[4],
        );

        uniqueStudents.add(student);
      }
    }

    return uniqueStudents;
  }

  void readExcelFile(File file) async {
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<List<Data?>> sheet = excel['Sheet1'].rows;
    List<List<String>> excelData = [];

    for (var row in sheet) {
      List<String> rowStrings = [];
      for (var index = 0; index < 5; index++) {
        rowStrings.add(row[index]?.value?.toString() ?? '');
      }
      excelData.add(rowStrings);
    }

    List<List<String>> existingData = state.students.map((student) {
      return [
        student.name,
        student.email,
        student.phoneNo.toString(),
        student.occupation.name.toString(),
        student.occDetail,
      ];
    }).toList();

    excelData.addAll(existingData);

    addDataToSheet(excelData);
  }

  void addStudent({required Student student}) {
    List<Student> students = state.students;
    students.add(student);
    state = state.copyWith(
      students: students,
    );
  }

  void removeStudent({required Student student}) {
    state = state.copyWith(
      students: state.students.where((s) => s.email != student.email).toList(),
    );
  }

  void modifyStudent({required Student student}) {
    state = state.copyWith(
      students: state.students.map((s) {
        return s.email == student.email ? student : s;
      }).toList(),
    );
  }
}

final createBatchProvider = StateNotifierProvider<CreateBatchNotifier, Batch>(
    (ref) => CreateBatchNotifier());
