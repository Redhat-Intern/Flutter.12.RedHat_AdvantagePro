import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pages/test_page/conduct_live_test.dart';
import '../../../pages/test_page/test_creator.dart';
import '../../../pages/test_page/live_test_result.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
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
      batchData: batchData,
      dayIndex: dayIndex,
      day: day,
    );

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

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
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => toMove,
                  ),
                ),
                child: Container(
                  width: width,
                  height: height * 0.0525,
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                    right: width * 0.03,
                    top: height * 0.006,
                    bottom: height * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: colorData.backgroundColor(1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: isConducted
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, currentIndex) {
                            return Container(
                              margin: EdgeInsets.only(right: width * 0.03),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: colorData.secondaryColor(.4),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: "absentStudents[currentIndex]",
                                  size: sizeData.regular,
                                  color: colorData.primaryColor(.6),
                                  weight: FontWeight.w800,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CustomText(
                            text: "Test is created but not conducted!",
                            color: colorData.fontColor(.4),
                          ),
                        ),
                ),
              )
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
      },
    );
  }
}
