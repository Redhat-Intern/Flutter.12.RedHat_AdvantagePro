import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';
import 'student_namer.dart';

class StudentReportTable extends ConsumerStatefulWidget {
  const StudentReportTable({
    super.key,
    required this.studentsData,
    required this.streams,
    required this.batchID,
  });
  final List<Map> studentsData;
  final List<Stream<DocumentSnapshot<Map<String, dynamic>>>> streams;
  final String batchID;

  @override
  ConsumerState<StudentReportTable> createState() => _StudentReportTableState();
}

class _StudentReportTableState extends ConsumerState<StudentReportTable> {
  List<String> searchData = ["attendance", "live Test", "daily Test"];
  int searchDataIndex = 0;
  LinkedScrollControllerGroup commonCtr = LinkedScrollControllerGroup();
  // Initialize controllers dynamically in initState
  List<ScrollController> controllers = [];

  List<Map> studentsData = [];
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  getStudentsData() async {
    QuerySnapshot<Map<String, dynamic>> docsSnapShot = await FirebaseFirestore
        .instance
        .collection("users")
        .where("userRole", isEqualTo: "student")
        .get();
    setState(() {
      studentsData = docsSnapShot.docs
          .where((element) {
            bool isFound = false;
            for (Map<dynamic, dynamic> i in widget.studentsData) {
              if (element.id == i.values.first) {
                isFound = true;
              }
            }
            return isFound;
          })
          .map((e) => Map.from(e.data()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    stream = widget.streams[0];
    for (int i = 0; i <= widget.studentsData.length; i++) {
      controllers.add(commonCtr.addAndGet());
    }
    getStudentsData();
  }

  @override
  void dispose() {
    // Dispose controllers in dispose
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Students",
                size: sizeData.subHeader,
                color: colorData.fontColor(.8),
                weight: FontWeight.w700,
              ),
              Container(
                height: height * 0.035,
                padding: EdgeInsets.only(left: width * 0.02),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                    color: colorData.fontColor(.8),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 0,
                  alignment: Alignment.center,
                  hint: CustomText(
                    text: searchData[searchDataIndex]
                            .toString()[0]
                            .toUpperCase() +
                        searchData[searchDataIndex].toString().substring(1),
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w600,
                  ),
                  dropdownColor: colorData.secondaryColor(1),
                  items: searchData
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: CustomText(
                            text: e.toString()[0].toUpperCase() +
                                e.toString().substring(1),
                            size: sizeData.regular,
                            color: colorData.fontColor(.8),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      searchDataIndex = searchData.indexOf(value!);
                      stream = widget.streams[searchDataIndex];
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            child: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    Map<String, dynamic> snapshotData = snapshot.data!.data()!;

                    return ListView.builder(
                      padding: EdgeInsets.only(left: width * 0.01),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: studentsData.length + 1,
                      itemBuilder: (context, index) {
                        // Header
                        if (index == 0) {
                          return Container(
                            height: height * .05,
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.008),
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
                                child: ListView.builder(
                                  controller: controllers[index],
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshotData.length,
                                  itemBuilder: (context, index) => SizedBox(
                                    width: width * .2,
                                    child: Center(
                                      child: CustomText(
                                        text: "Day $index",
                                        size: sizeData.medium,
                                        color: colorData.fontColor(.8),
                                        weight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        } else {
                          String studentID =
                              studentsData[index - 1]["id"][widget.batchID];

                          return Container(
                            height: height * 0.065,
                            margin: EdgeInsets.only(bottom: height * 0.01),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: StudentReportTableNamer(
                                      name: studentsData[index - 1]["name"],
                                      id: studentID,
                                      imageUrl: studentsData[index - 1]
                                              ["imagePath"] ??
                                          studentsData[index - 1]["name"][0]),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ListView.builder(
                                    controller: controllers[index],
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshotData.length,
                                    itemBuilder: (context, valueIndex) {
                                      if (searchDataIndex == 0) {
                                        bool attendanceCheck =
                                            snapshotData[valueIndex.toString()]
                                                [studentID];
                                        String attendance =
                                            attendanceCheck == true
                                                ? "Present"
                                                : "Absent";
                                        return SizedBox(
                                          width: width * .2,
                                          child: Center(
                                            child: CustomText(
                                              text: attendance,
                                              color: attendanceCheck
                                                  ? Colors.green.shade600
                                                  : Colors.red,
                                              weight: FontWeight.w800,
                                              size: sizeData.medium,
                                            ),
                                          ),
                                        );
                                      } else if (searchDataIndex == 2) {
                                        int? totalMark =
                                            snapshotData[valueIndex.toString()]
                                                            ["answers"]
                                                        [studentID] !=
                                                    null
                                                ? snapshotData[valueIndex
                                                        .toString()]["answers"]
                                                    [studentID]["totalMark"]
                                                : null;
                                        return SizedBox(
                                          width: width * .2,
                                          child: Center(
                                            child: CustomText(
                                              text: totalMark
                                                  .toString()
                                                  .toUpperCase(),
                                              color: totalMark == null
                                                  ? Colors.red
                                                  : null,
                                              weight: FontWeight.w800,
                                              size: sizeData.medium,
                                            ),
                                          ),
                                        );
                                      } else {
                                        int? totalMark =
                                            snapshotData[valueIndex.toString()]
                                                        ["totalScores"] !=
                                                    null
                                                ? snapshotData[
                                                        valueIndex.toString()]
                                                    ["totalScores"][studentID]
                                                : null;
                                        return SizedBox(
                                          width: width * .2,
                                          child: Center(
                                            child: CustomText(
                                              text: totalMark.toString(),
                                              color: totalMark == null
                                                  ? Colors.red
                                                  : null,
                                              weight: FontWeight.w800,
                                              size: sizeData.medium,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Image.asset(
                          "assets/icons/MT1.png",
                          width: width * .65,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        const CustomText(text: "No data has been found yet!")
                      ],
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
