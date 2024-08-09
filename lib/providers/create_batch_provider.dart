import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/batch.dart';
import '../model/student.dart';
import '../model/user.dart';

class CreateBatchNotifier extends StateNotifier<Batch> {
  CreateBatchNotifier() : super(Batch.empty());

  void clearData() {
    state = Batch.empty();
  }

  void setBatchName(String name) {
    state = state.copyWith(name: name);
  }

  void updateTime() {
    state = state.copyWith(creationTime: DateTime.now());
  }

  void updateName({required String newName}) {
    state = state.copyWith(name: newName);
  }

  void updateCertificate({required Map<String, dynamic> newCertificateData}) {
    state = state.copyWith(
      certificateData: newCertificateData,
    );
  }

  void updateDates({required List<String> newDates}) {
    state = state.copyWith(dates: newDates);
  }

  void updateStaffs({required List<UserModel> staffsList}) {
    state = state.copyWith(staffs: staffsList);
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
          registrationID: row[0],
          name: row[1],
          email: row[2],
          phoneNo: row[3].toString(),
          occupation: StudentOcc.college.name.toLowerCase() ==
                  row[4].toString().toLowerCase()
              ? StudentOcc.college
              : StudentOcc.professional,
          occDetail: row[5],
        );

        uniqueStudents.add(student);
      }
    }

    return uniqueStudents;
  }

  void readExcelFile(
    File file,
    String name,
  ) async {
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<List<Data?>> sheet = excel[excel.getDefaultSheet()!].rows;
    List<List<String>> excelData = [];

    if (sheet.isNotEmpty) {
      for (var row in sheet) {
        List<String> rowStrings = [];
        for (var index = 0; index < 6; index++) {
          if (index == 3) {
            rowStrings.add(row[index]?.value != null
                ? row[index]!
                    .value
                    .toString()
                    .substring(0, row[index]!.value.toString().length - 2)
                : '');
          } else {
            rowStrings.add(row[index]?.value?.toString() ?? '');
          }
        }
        excelData.add(rowStrings);
      }

      List<List<String>> existingData = state.students.map((student) {
        return [
          student.registrationID,
          student.name,
          student.email,
          student.phoneNo,
          student.occupation.name,
          student.occDetail,
        ];
      }).toList();

      excelData.addAll(existingData);

      addDataToSheet(excelData);
    } else {
      print("Error while uploading data");
    }
  }

  bool addStudent({required Student student}) {
    List<Student> students = state.students;
    bool checkMatch = students
        .where((data) => data.registrationID == student.registrationID)
        .isNotEmpty;
    if (checkMatch) {
      return false;
    } else {
      students.add(student);
      state = state.copyWith(
        students: students,
      );
      return true;
    }
  }

  void removeStudent({required Student student}) {
    state = state.copyWith(
      students: state.students.where((s) => s.email != student.email).toList(),
    );
  }

  void modifyStudent({required Student student}) {
    state = state.copyWith(
      students: state.students.map((s) {
        return s.registrationID == student.registrationID ? student : s;
      }).toList(),
    );
  }
}

final createBatchProvider = StateNotifierProvider<CreateBatchNotifier, Batch>(
    (ref) => CreateBatchNotifier());
