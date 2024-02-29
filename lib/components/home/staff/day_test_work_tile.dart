import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pages/test_page/test_creator.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'work_tile_placeholder.dart';

class DayTestWorkTile extends ConsumerWidget {
  const DayTestWorkTile(
      {super.key,
      required this.dayIndex,
      required this.batchData,
      required this.day});

  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget toGo = TestCreater(
      batchData: batchData,
      day: day,
      dayIndex: dayIndex,
      testType: TestType.daily,
    );

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("dayTest")
          .doc(batchData["name"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshot.data!.data()!.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CustomText(
                    text: "DAY TEST:",
                    color: colorData.fontColor(.5),
                    weight: FontWeight.w800,
                    size: sizeData.regular,
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  CustomText(
                    text: WorkStatus.values[0].name.toUpperCase(),
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w800,
                    size: sizeData.medium,
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(aspectRatio * 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade200, Colors.red],
                      ),
                    ),
                    child: CustomText(
                      text: "3",
                      color: colorData.sideBarTextColor(1),
                      weight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              // CustomListText(data: ["hello","how"], todo: (){}, index: , getChild: getChild)
            ],
          );
        } else {
          return WorkTilePlaceHolder(
            header: "day test",
            toGO: toGo,
            value: "Not created",
            placeholder: "Tap to create a day test",
          );
        }
      },
    );
  }
}
