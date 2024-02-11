import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/home/admin/recent_place_holder.dart';
import '../../components/home/admin/create_batch_button.dart';
import '../../components/home/header.dart';
import '../../components/home/admin/recent.dart';
import '../../components/home/admin/search.dart';
import '../../components/home/admin/staffs_list.dart';

class StaffHome extends ConsumerWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("batches").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                      snapshot.data!.docs;

                  List<Map<String, Map<String, dynamic>>> recentBatches = [];
                  for (QueryDocumentSnapshot<Map<String, dynamic>> i in docs) {
                    Map<String, dynamic> data = i.data();
                    int count = List.from(data["students"]).length;
                    recentBatches.add({
                      data["certificateImg"]: {
                        "name": data["certificateName"],
                        "count": count
                      }
                    });
                  }
                  return Recent(recentBatches: recentBatches);
                } else {
                  return const RecentPlaceHolder();
                }
              } else {
                return const Center(
                  child: Text("loading"),
                );
              }
            }),
      ],
    );
  }
}

