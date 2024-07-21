import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../components/common/waiting_widgets/certification_waiting.dart';
import '../../components/home/student/certifications.dart';
import '../../components/home/student/course_content.dart';
import '../../components/home/header.dart';
import '../../functions/read/certificate_data.dart';
import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/size_data.dart';

class StudentHome extends ConsumerWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userData = ref.watch(userDataProvider);
    String batchName = Map.from(userData.currentBatch!).keys.first.toString();
    String studentID = Map.from(userData.id!)[batchName];
    String email = userData.email;

    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        SizedBox(
          height: height * 0.02,
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

              readCertificateData(
                batchName: batchData["name"],
                certificateName: batchData["certificateID"],
                ref: ref,
              );

              return Expanded(
                child: Column(
                  children: [
                    Certifications(batchList: data),
                    SizedBox(
                      height: height * 0.02,
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
