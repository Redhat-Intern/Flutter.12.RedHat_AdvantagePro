import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../components/report/student_namer.dart';
import '../model/user.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';

class AttendencePage extends ConsumerStatefulWidget {
  const AttendencePage({
    super.key,
    required this.docRef,
    required this.students,
    required this.day,
    required this.dayIndex,
  });

  final DocumentReference<Map<String, dynamic>> docRef;
  final List<Map<dynamic, dynamic>> students;
  final String day;
  final int dayIndex;

  @override
  ConsumerState<AttendencePage> createState() => _AttendencePageState();
}

class _AttendencePageState extends ConsumerState<AttendencePage> {
  List<UserModel> students = [];
  Map<String, bool?> toggle = {};

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .where('userRole', isEqualTo: "student")
        .get()
        .then((value) {
      setState(() {
        students = value.docs
            .where((element) {
              bool isFound = false;
              for (Map<dynamic, dynamic> i in widget.students) {
                if (element.id == i.values.first) {
                  isFound = true;
                }
              }
              return isFound;
            })
            .map((e) => UserModel.fromJson(e.data()))
            .toList();
      });
    });
  }

  void setAttendence(
      {required String studentID, required bool attendence}) async {
    await widget.docRef.set({
      widget.dayIndex.toString(): {studentID: attendence}
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: StreamBuilder(
            stream: widget.docRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic>? data = snapshot.data!.data();
                Map<String, dynamic> attendenceData = data != null &&
                        data.isNotEmpty &&
                        data[widget.dayIndex.toString()] != null
                    ? data[widget.dayIndex.toString()]
                    : {};
                attendenceData.forEach((key, value) {
                  toggle[key] = value;
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CustomBackButton(),
                        const Spacer(),
                        CustomText(
                          text: "ATTENDENCE",
                          size: sizeData.header,
                          color: colorData.fontColor(1),
                          weight: FontWeight.w600,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        CustomText(
                          text: widget.day,
                          size: sizeData.medium,
                          color: colorData.fontColor(.6),
                          weight: FontWeight.w800,
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    CustomText(
                      text: "Students",
                      size: sizeData.subHeader,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: width * 0.01),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: students.length + 1,
                        itemBuilder: (context, index) {
                          // Header
                          if (index == 0) {
                            return Container(
                              height: height * .05,
                              margin: EdgeInsets.symmetric(
                                  vertical: height * 0.008),
                              child: Row(children: [
                                Expanded(
                                  flex: 5,
                                  child: CustomText(
                                    text: "Name",
                                    size: sizeData.medium,
                                    color: colorData.fontColor(.8),
                                    weight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: CustomText(
                                      text: "Attendence",
                                      size: sizeData.medium,
                                      color: colorData.fontColor(.8),
                                      weight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          } else {
                            String studentID =
                                widget.students[index - 1].keys.first;

                            return Container(
                              height: height * 0.065,
                              margin: EdgeInsets.only(bottom: height * 0.01),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: StudentReportTableNamer(
                                        name: students[index - 1].name,
                                        id: widget
                                            .students[index - 1].keys.first,
                                        imageUrl:
                                            students[index - 1].imagePath),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          color: Colors.transparent,
                                          child: CustomText(
                                            text: toggle[studentID] == null
                                                ? "Not Set"
                                                : toggle[studentID]!
                                                    ? "Present"
                                                    : "Absent",
                                            color: toggle[studentID] == null
                                                ? colorData.fontColor(.9)
                                                : toggle[studentID]!
                                                    ? Colors.green
                                                    : Colors.red,
                                            weight: FontWeight.w800,
                                            size: sizeData.medium,
                                          ),
                                        ),
                                        FlutterSwitch(
                                            height: height * 0.032,
                                            width: width * 0.12,
                                            duration: Durations.short3,
                                            padding: 2,
                                            value: toggle[studentID] ?? false,
                                            onToggle: (value) {
                                              setState(() {
                                                toggle[studentID] = value;
                                                setAttendence(
                                                    studentID: studentID,
                                                    attendence: value);
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const CustomText(text: "text");
              }
            },
          ),
        ),
      ),
    );
  }
}
