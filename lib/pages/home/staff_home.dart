import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/home/staff/batches.dart';
import '../../model/notification.dart';
import '../../providers/notification_data_provider.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/home/admin/recent_place_holder.dart';
import '../../components/home/header.dart';

class StaffHome extends ConsumerWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = ref.watch(userDataProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        // StreamBuilder(
        //     stream: FirebaseFirestore.instance
        //         .collection("batches")
        //         .where("staffs", arrayContains: userData["email"])
        //         .snapshots(),
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
        //           return StaffBatches(batches: recentBatches);
        //         } else {
        //           return const RecentPlaceHolder(
        //             header: "Batches",
        //             text: "You are not yet assigned with any batches!",
        //           );
        //         }
        //       } else {
        //         return const Center(
        //           child: Text("loading"),
        //         );
        //       }
        //     }),
      ],
    );
  }
}
