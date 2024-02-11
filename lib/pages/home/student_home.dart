
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/home/student/certifications.dart';
import '../../components/home/student/course_content.dart';
import '../../components/home/header.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class StudentHome extends ConsumerWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        const Certifications(),
        // StreamBuilder(
        //     stream:
        //         FirebaseFirestore.instance.collection("batches").snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         if (snapshot.data!.docs.isNotEmpty) {
        //           List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        //               snapshot.data!.docs;

        //           List<Map<String, Map<String, dynamic>>> recentBatches = [];
        //           for (QueryDocumentSnapshot<Map<String, dynamic>> i in docs) {
        //             Map<String, dynamic> data = i.data();
        //             int count = List.from(data["students"]).length;
        //             recentBatches.add({
        //               data["certificateImg"]: {
        //                 "name": data["certificateName"],
        //                 "count": count
        //               }
        //             });
        //           }
        //           return Recent(recentBatches: recentBatches);
        //         } else {
        //           return const RecentPlaceHolder();
        //         }
        //       } else {
        //         return const Center(
        //           child: Text("loading"),
        //         );
        //       }
        //     }),
        const CourseContent(),
        SizedBox(
          height: height * .02,
        ),
      ],
    );
  }
}
