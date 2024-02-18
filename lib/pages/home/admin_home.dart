import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/size_data.dart';

import '../../components/home/admin/recent_place_holder.dart';
import '../../components/home/admin/create_batch_button.dart';
import '../../components/home/header.dart';
import '../../components/home/admin/recent.dart';
import '../../components/home/admin/search.dart';
import '../../components/home/admin/staffs_list.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        const Search(),
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("batches").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                      snapshot.data!.docs;

                  List<Map<String, dynamic>> recentBatches = [];
                  for (QueryDocumentSnapshot<Map<String, dynamic>> i in docs) {
                    Map<String, dynamic> data = i.data();
                    int count = List.from(data["students"]).length;
                    recentBatches.add({
                      "certificateID": data["certificateID"],
                      "count": count,
                      "id": i.id,
                    });
                  }
                  return Recent(recentBatches: recentBatches);
                } else {
                  return const RecentPlaceHolder(
                    header: "Recent",
                    text: "No Batches have been crested till NOW!",
                  );
                }
              } else {
                return const Center(
                  child: Text("loading"),
                );
              }
            }),
        const StaffsList(),
        const CreateBatchButton(),
        SizedBox(
          height: height * 0.02,
        ),
      ],
    );
  }
}
