import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/back_button.dart';
import 'package:redhat_v1/components/report/staffs_report_list.dart';
import 'package:redhat_v1/components/report/student_report_table.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class DetailedBatchReport extends ConsumerStatefulWidget {
  const DetailedBatchReport({super.key});

  @override
  ConsumerState<DetailedBatchReport> createState() =>
      _DetailedBatchReportState();
}

class _DetailedBatchReportState extends ConsumerState<DetailedBatchReport> {
  String batchName = "RHCSA212025";
  Map<String, Map<String, dynamic>> studentsData = {
    "RSCA001STU001": {
      "name": "Student 1",
      "photo": "assets/images/staff1.png",
      "attendance": {
        "Day1": true,
        "Day2": false,
        "Day3": true
      },
      "tests": {
        "Test1": 85.0,
        "Test2": 73.0,
        "Test3": 42.0,
      },
      "exams":{
        "Exam1": 85.0,
        "Exam2": 73.0,
        "Exam3": 42.0,
      }
    },
    "RSCA001STU002": {
      "name": "Student 2",
      "photo": "assets/images/staff1.png",
      "attendance": {
        "Day1": true,
        "Day2": true,
        "Day3": false
      },
      "tests": {
        "Test1": 91.0,
        "Test2": 55.0,
        "Test3": 78.0,
      },
      "exams":{
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
                  const Spacer(
                    flex: 2,
                  ),
                  CustomText(
                    text: batchName.toUpperCase(),
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w800,
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              const StaffsReportList(staffsListData: [], adminStaffData: {}),
              SizedBox(
                height: height * 0.03,
              ),
              StudentReportTable(studentsData: studentsData),
            ],
          ),
        ),
      ),
    );
  }
}
