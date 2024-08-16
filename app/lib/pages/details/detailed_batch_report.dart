import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/back_button.dart';
import '../../components/report/staffs_report_list.dart';
import '../../components/report/student_report_table.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../components/common/text.dart';

class DetailedBatchReport extends ConsumerStatefulWidget {
  const DetailedBatchReport({super.key, required this.searchData});
  final Map<String, dynamic> searchData;

  @override
  ConsumerState<DetailedBatchReport> createState() =>
      _DetailedBatchReportState();
}

class _DetailedBatchReportState extends ConsumerState<DetailedBatchReport> {
  Map<String, Map<String, dynamic>> studentsData = {
    "RSCA001STU001": {
      "name": "Student 1",
      "photo": "assets/images/staff1.png",
      "attendance": {"Day1": true, "Day2": false, "Day3": true},
      "tests": {
        "Test1": 85.0,
        "Test2": 73.0,
        "Test3": 42.0,
      },
      "exams": {
        "Exam1": 85.0,
        "Exam2": 73.0,
        "Exam3": 42.0,
      }
    },
    "RSCA001STU002": {
      "name": "Student 2",
      "photo": "assets/images/staff1.png",
      "attendance": {"Day1": true, "Day2": true, "Day3": false},
      "tests": {
        "Test1": 91.0,
        "Test2": 55.0,
        "Test3": 78.0,
      },
      "exams": {
        "Exam1": 85.0,
        "Exam2": 73.0,
        "Exam3": 42.0,
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    List<MapEntry> staffList =
        List.from(widget.searchData["staffs"]).map((element) {
          Map<String,String> data = Map<String,String>.from(element);
      return MapEntry(data.keys.first, data.values.first);
    }).toList();

    List<Map> studentsList = List.from(widget.searchData["students"])
        .map((e) => Map.from(e))
        .toList();

    List<Stream<DocumentSnapshot<Map<String, dynamic>>>> streams = [
      FirebaseFirestore.instance
          .collection("attendance")
          .doc(widget.searchData["name"])
          .snapshots(),
      FirebaseFirestore.instance
          .collection("liveTest")
          .doc(widget.searchData["name"])
          .snapshots(),
      FirebaseFirestore.instance
          .collection("dailyTest")
          .doc(widget.searchData["name"])
          .snapshots(),
    ];

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(flex: 2),
                  CustomText(
                    text: widget.searchData["name"].toUpperCase(),
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w800,
                  ),
                  const Spacer(flex: 3),
                ],
              ),
              SizedBox(height: height * 0.03),
              StaffsReportList(
                staffsListData: staffList,
              ),
              SizedBox(height: height * 0.03),
              StudentReportTable(studentsData: studentsList, streams: streams),
            ],
          ),
        ),
      ),
    );
  }
}
