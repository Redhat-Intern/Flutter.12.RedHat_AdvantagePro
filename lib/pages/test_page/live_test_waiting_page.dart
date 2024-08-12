import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

import '../../model/user.dart';
import '../../providers/livetest_provider.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'live_test_attender.dart';

class LiveTestWaitingRoom extends ConsumerStatefulWidget {
  const LiveTestWaitingRoom({
    super.key,
    required this.dayIndex,
    required this.batchData,
    required this.day,
    required this.todo,
  });
  final int dayIndex;
  final Map<String, dynamic> batchData;
  final String day;
  final Function todo;

  @override
  ConsumerState<LiveTestWaitingRoom> createState() =>
      _LiveTestWaitingRoomState();
}

class _LiveTestWaitingRoomState extends ConsumerState<LiveTestWaitingRoom> {
  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider).key;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('liveTest')
            .doc(widget.batchData['name'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic> data = snapshot.data!.data()!;
            Map<String, dynamic> testData =
                Map.from(data[widget.dayIndex.toString()]);
            bool? toStart = testData["status"];

            Future(() {
              ref.read(liveTestProvider.notifier).updateTestData(testData);
            });

            DocumentReference<Map<String, dynamic>> documentRef =
                FirebaseFirestore.instance
                    .collection("liveTest")
                    .doc(widget.batchData['name']);
            print(testData["status"]);

            if (toStart == null || toStart == false) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: width * 0.04,
                      right: width * 0.04,
                      top: height * 0.02,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomBackButton(
                              otherMethod: () => widget.todo(false),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            CustomText(
                              text: "LIVE TEST",
                              size: sizeData.header,
                              color: colorData.fontColor(1),
                              weight: FontWeight.w600,
                            ),
                            const Spacer(),
                            CustomText(
                              text: widget.day,
                              size: sizeData.medium,
                              color: colorData.fontColor(.6),
                              weight: FontWeight.w800,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/images/prepare.png",
                          height: height * .4,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        CustomText(
                          text: "Prepare till the test starts",
                          size: sizeData.subHeader,
                          color: colorData.fontColor(.6),
                          weight: FontWeight.w800,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return LiveTestAttender(
                testData: testData,
                documentRef: documentRef,
                dayIndex: widget.dayIndex.toString(),
                userID: userData.studentId![widget.batchData["name"]]!,
                batchName: widget.batchData["name"],
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
