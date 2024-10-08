import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../components/common/waiting_widgets/certification_waiting.dart';
import '../../components/home/student/certifications.dart';
import '../../components/home/student/course_content.dart';
import '../../components/home/header.dart';
import '../../functions/read/course_data.dart';
import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/size_data.dart';

class StudentHome extends ConsumerWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userData = ref.watch(userDataProvider).key;
    String batchName = Map.from(userData.currentBatch!).keys.first.toString();
    String studentID = Map.from(userData.studentId!)[batchName];
    String email = userData.email;

    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        SizedBox(
          height: height * 0.03,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("batches")
              .where("students", arrayContains: {studentID: email}).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<Map<String, dynamic>> data = [];
              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                  snapshot.data!.docs;
              Map<String, dynamic> allBatches = userData.batch!;
              List<String> batchIDList = allBatches.keys.toList();
              Map<String, dynamic> batchData = docs
                  .firstWhere((element) => element.data()["completed"] == null)
                  .data();

              for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                  in docs.where((element) =>
                      batchIDList.contains(element.id.toUpperCase()))) {
                List<dynamic> dateStrings = doc.data()["dates"];
                List<DateTime> dates = dateStrings
                    .map((e) => DateFormat('dd-MM-yyyy').parse(e))
                    .toList();
                dates.sort((a, b) => a.compareTo(b));
                data.add(doc.data());
              }

              CourseService(ref: ref).readCourseData(
                batchName: batchData["name"],
                courseName: batchData["courseID"],
                isFromBatch: true,
              );

              return Expanded(
                child: Column(
                  children: [
                    Certifications(batchList: data),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CourseContent(batchData: batchData),
                  ],
                ),
              );
            } else {
              return const Expanded(
                child: Column(
                  children: [CertificationWaitingWidget(), Spacer()],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
