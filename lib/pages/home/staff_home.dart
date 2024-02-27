import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../components/common/text.dart';
import '../../components/home/staff/batches.dart';
import '../../components/home/staff/work_setter.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/home/admin/recent_place_holder.dart';
import '../../components/home/header.dart';

class StaffHome extends ConsumerWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = ref.watch(userDataProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        SizedBox(
          height: height * 0.02,
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection("batches").where(
                "staffs",
                arrayContains: {userData["id"]: userData["email"]}).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    snapshot.data!.docs;

                List<Map<String, dynamic>> recentBatches = [];
                List<QueryDocumentSnapshot<Map<String, dynamic>>> liveBatches =
                    [];

                for (QueryDocumentSnapshot<Map<String, dynamic>> i in docs) {
                  Map<String, dynamic> data = i.data();
                  int count = List.from(data["students"]).length;
                  List<DateTime> dates = List.from(data["dates"])
                      .map((e) => DateFormat('dd-MM-yyyy').parse(e))
                      .toList();
                  dates.sort((a, b) => b.compareTo(a));
                  bool isLive = DateTime.now()
                          .compareTo(dates[0].add(const Duration(hours: 24))) !=
                      1;
                  if (isLive) {
                    liveBatches.add(i);
                  }

                  recentBatches.add({
                    "certificateID": data["certificateID"],
                    "count": count,
                    "id": i.id,
                    "isLive": isLive,
                  });
                }

                return Expanded(
                  child: Column(
                    children: [
                      StaffBatches(batches: recentBatches),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      liveBatches.isNotEmpty
                          ? Expanded(
                              child: BatchWorkSetter(
                                liveBatches: liveBatches,
                              ),
                            )
                          : const Center(
                              child: CustomText(
                                text: "No live Batches",
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return const Expanded(
                  child: Column(
                    children: [
                      RecentPlaceHolder(
                        header: "Batches",
                        text: "You are not yet assigned with any batches!",
                      ),
                      Spacer(),
                    ],
                  ),
                );
              }
            }),
      ],
    );
  }
}
