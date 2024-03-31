import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:redhat_v1/components/common/page_header.dart';
import 'package:redhat_v1/components/common/text_list.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class DailyTestResult extends ConsumerWidget {
  const DailyTestResult({
    super.key,
    required this.dayIndex,
    required this.batchData,
    required this.day,
  });
  final int dayIndex;
  final Map<String, dynamic> batchData;
  final String day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("dailyTest")
                  .doc(batchData["name"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map<String, dynamic> testData =
                    Map.from(snapshot.data!.data()![dayIndex.toString()]);

                Map<String, dynamic>? answerData = testData["answers"];

                bool isAllAttended = answerData != null
                    ? answerData.length ==
                        List.from(batchData["students"]).length
                    : false;

                List<String> attendedStudents =
                    answerData != null ? answerData.keys.toList() : [];

                List<String> notAttendedStudents =
                    List.from(batchData["students"])
                        .map((e) =>
                            Map<String, dynamic>.from(e).keys.first.toString())
                        .toList();
                notAttendedStudents.removeWhere(
                    (element) => attendedStudents.contains(element));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeader(
                      tittle: "DAILY TEST RESULT",
                      secondaryWidget: CustomText(
                        text: day,
                        size: sizeData.medium,
                        color: colorData.fontColor(.6),
                        weight: FontWeight.w800,
                        height: 2.25,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomText(
                      text: "NOT ATTENDED STUDENTS:",
                      color: colorData.fontColor(.5),
                      weight: FontWeight.w800,
                    ),
                    SizedBox(height: height * 0.01),
                    CustomListText(
                        data: notAttendedStudents,
                        placeholder: "All Attended the test successfully!",
                        getChild: (index) => notAttendedStudents[index]),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomText(
                      text: "ATTENDED STUDENTS:",
                      color: colorData.fontColor(.5),
                      weight: FontWeight.w800,
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: attendedStudents.length,
                        itemBuilder: (context, index) {
                          
                          print(answerData![attendedStudents[index]]);
                          return FinalResultTile(
                            index: index,
                            name: "name",
                            imageURL: "N",
                            points: "763",
                            startTime: DateTime.now(),
                            endTime: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class FinalResultTile extends ConsumerWidget {
  const FinalResultTile({
    super.key,
    required this.index,
    required this.name,
    required this.imageURL,
    required this.points,
    required this.startTime,
    required this.endTime,
  });

  final int index;
  final String name;
  final String imageURL;
  final String points;
  final DateTime startTime;
  final DateTime endTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    return Container(
      padding: EdgeInsets.only(
        top: height * 0.01,
        bottom: height * 0.01,
        left: width * 0.02,
        right: width * 0.025,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: (index + 1).toString().padLeft(2, " "),
            color: colorData.fontColor(.3),
            weight: FontWeight.w800,
          ),
          SizedBox(width: width * 0.03),
          Container(
            height: aspectRatio * 110,
            width: aspectRatio * 110,
            padding: EdgeInsets.all(aspectRatio * 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorData.secondaryColor(1),
            ),
            alignment: Alignment.center,
            child: imageURL.length == 1
                ? CustomText(
                    text: imageURL,
                    size: sizeData.superLarge,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w800,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(imageURL),
                  ),
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: name,
                  size: sizeData.medium,
                  weight: FontWeight.w700,
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text:
                            DateFormat('hh:mm:ss a', 'en_US').format(startTime),
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.6),
                        size: sizeData.small,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: DateFormat('hh:mm:ss a', 'en_US').format(endTime),
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.6),
                        size: sizeData.small,
                        align: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: width * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.005, horizontal: width * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  colorData.secondaryColor(.4),
                  colorData.secondaryColor(.9),
                ],
              ),
            ),
            child: CustomText(
              text: points,
              size: sizeData.medium,
              color: colorData.primaryColor(1),
              weight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
