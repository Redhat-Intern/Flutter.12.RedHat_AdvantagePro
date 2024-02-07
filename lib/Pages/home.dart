import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redhat_v1/components/home/recent_place_holder.dart';

import '../Utilities/theme/size_data.dart';

import '../components/home/create_batch_button.dart';
import '../components/home/header.dart';
import '../components/home/recent.dart';
import '../components/home/search.dart';
import '../components/home/staffs_list.dart';
import '../components/home/wisher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    // double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      children: [
        const Header(),
        SizedBox(
          height: height * 0.015,
        ),
        const Wisher(),
        const Spacer(),
        const Search(),
        const Spacer(),
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
                  return RecentPlaceHolder();
                }
              } else {
                return const Center(
                  child: Text("loading"),
                );
              }
            }),
        const Spacer(),
        const StaffsList(),
        const Spacer(flex: 2,),
        const CreateBatchButton(),
        const Spacer(flex: 2,),
      ],
    );
  }
}
