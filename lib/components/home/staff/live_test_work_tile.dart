import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../pages/test_page/conduct_live_test.dart';
import '../../../pages/test_page/test_creator.dart';
import '../../../pages/test_page/live_test_result.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'work_tile_container.dart';
import 'work_tile_placeholder.dart';

class LiveTestWorkTile extends ConsumerWidget {
  const LiveTestWorkTile(
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
      dayIndex: dayIndex,
      day: day,
      testType: TestType.live,
    );

    Widget conduct = ConductLiveTest(
      batchData: batchData,
      dayIndex: dayIndex,
      day: day,
    );

    Widget result = LiveTestResult(
      dayIndex: dayIndex,
      day: day,
      batchName: batchData["name"],
    );

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    int cmpDate = DateTime.now().compareTo(
        DateFormat("dd-MM-yyyy").parse(day).add(const Duration(hours: 24)));

    bool datePassed = cmpDate == 1;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("liveTest")
          .doc(batchData["name"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.exists &&
            snapshot.data!.data()!.isNotEmpty &&
            snapshot.data!.data()!.containsKey(dayIndex.toString())) {
          Map<String, dynamic> testData =
              Map.from(snapshot.data!.data()![dayIndex.toString()]);
          bool isConducted = testData.containsKey("result");

          Widget toMove = isConducted ? result : conduct;
          bool notDone = datePassed && testData.isEmpty;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CustomText(
                    text: "LIVE TEST:",
                    color: colorData.fontColor(.5),
                    weight: FontWeight.w800,
                    size: sizeData.small,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  CustomText(
                    text: isConducted ? "COMPLETED" : "PENDING..",
                    color: isConducted ? Colors.green : Colors.orange,
                    weight: FontWeight.w800,
                    size: sizeData.regular,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.008,
              ),
              notDone
                  ? const WorkTileContainer(
                      text: "Test has not been initiated. (REPORTED)")
                  : isConducted
                      ? GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => toMove,
                            ),
                          ),
                          child: WorkTileContainer(
                            textWidget: CustomText(
                                text: "Live Test Conducted Successfully 🥳",
                                color: Colors.green,
                                size: sizeData.medium,
                                weight: FontWeight.w800),
                          ),
                        )
                      : const WorkTileContainer(
                          text:
                              "Test is created but not conducted! (REPORTED)"),
            ],
          );
        } else {
          if (datePassed) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "LIVE TEST:",
                  color: colorData.fontColor(.5),
                  weight: FontWeight.w800,
                  size: sizeData.small,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                const WorkTileContainer(
                    text: "Test has not been initiated. (REPORTED)"),
              ],
            );
          } else {
            return WorkTilePlaceHolder(
              header: "live test",
              toGO: toGo,
              value: "NOT CREATED",
              placeholder: "Tap to create a live test",
            );
          }
        }
      },
    );
  }
}
