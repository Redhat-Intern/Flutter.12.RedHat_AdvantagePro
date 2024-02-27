import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'attendence_work_tile.dart';
import 'day_test_work_tile.dart';
import 'live_test_work_tile.dart';

class BatchDayWork extends ConsumerWidget {
  const BatchDayWork({
    super.key,
    required this.documentSnapshot,
    required this.dayIndex,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> batchData = documentSnapshot.data();
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.012),
      decoration: BoxDecoration(
        color: colorData.secondaryColor(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Update the couse contents",
                color: colorData.fontColor(.5),
                size: sizeData.regular,
                weight: FontWeight.bold,
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorData.primaryColor(.2),
                      colorData.primaryColor(1)
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: height * 0.005,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: CustomText(
                    text: "EDIT",
                    size: sizeData.regular,
                    color: colorData.secondaryColor(1),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          AttendenceWorkTile(
              dayIndex: dayIndex,
              batchData: batchData,
              day: batchData["dates"][dayIndex]),
          DayTestWorkTile(
              dayIndex: dayIndex,
              batchData: batchData,
              day: batchData["dates"][dayIndex]),
          LiveTestWorkTile(
              dayIndex: dayIndex,
              batchData: batchData,
              day: batchData["dates"][dayIndex]),
        ],
      ),
    );
  }
}
