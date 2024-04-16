import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/test.dart';
import '../../../providers/livetest_provider.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class RankingBoard extends ConsumerWidget {
  const RankingBoard({
    super.key,
    required this.currentTestField,
  });
  final TestField currentTestField;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    Map<String, dynamic> testData = ref.watch(liveTestProvider)!;

    if (testData["answers"] == null && testData["totalScores"] == null) {
      return const Center(
        child: CustomText(text: "NO one answered till NOW!"),
      );
    } else {
      Map asnweredStudents =
          testData["answers"][currentTestField.question] != null
              ? Map.from(testData["answers"][currentTestField.question])
              : {};
      Map studentsTotalScore = Map.from(testData["totalScores"]);

      studentsTotalScore.entries.toList().sort((MapEntry a, MapEntry b) {
        return int.parse(a.value.toString()).compareTo(
          int.parse(b.value.toString()),
        );
      });

      Map<String, dynamic> studentData =
          Map<String, dynamic>.from(testData["students"]);

      return Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: "RANKING BOARD",
              size: sizeData.subHeader,
              color: colorData.fontColor(.8),
              weight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.02,
              ),
              CustomText(
                text: "ANS:",
                weight: FontWeight.w800,
                color: colorData.fontColor(.6),
                size: sizeData.small,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Expanded(
                child: CustomText(
                  text: currentTestField.options[currentTestField.answer]!,
                  size: sizeData.medium,
                  weight: FontWeight.w700,
                  maxLine: 2,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              scrollDirection: Axis.vertical,
              itemCount: studentsTotalScore.length,
              itemBuilder: (context, index) {
                String studentID = studentsTotalScore.keys.toList()[index];
                String name = studentData[studentID]["name"].toString();
                Map? answerData = asnweredStudents[studentID] != null
                    ? Map.from(asnweredStudents[studentID])
                    : null;
                bool? isImproved = answerData != null
                    ? answerData["option"] == currentTestField.answer
                    : null;

                Color backgroundColor = index == 0
                    ? Colors.blue.shade200
                    : index == 1
                        ? Colors.green.shade200
                        : index == 2
                            ? Colors.orange.shade200
                            : colorData.secondaryColor(.4);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: width * (index < 3 ? (index * 0.02) : 0.08),
                        right: width * (index < 3 ? (index * 0.02) : 0.08),
                        bottom: height * 0.02,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: aspectRatio *
                                (100 - (index < 3 ? (index * 5) : 20)),
                            width: aspectRatio *
                                (100 - (index < 3 ? (index * 5) : 20)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: colorData.backgroundColor(1),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "A",
                              size: aspectRatio *
                                  (60 - (index < 3 ? (index * 2.5) : 15)),
                              weight: FontWeight.w800,
                              color: colorData.fontColor(.8),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: name,
                                  size: index < 2 ? sizeData.medium : null,
                                  weight: FontWeight.w700,
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                CustomText(
                                  text: answerData != null
                                      ? "${answerData["time"]} s"
                                      : "...",
                                  size: index < 3 ? sizeData.medium : null,
                                  color: colorData.fontColor(1),
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          CustomText(
                            text: studentsTotalScore[studentID].toString(),
                            size: index < 2
                                ? sizeData.subHeader
                                : sizeData.medium,
                            color: colorData.primaryColor(1),
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    isImproved != null
                        ? Positioned(
                            top: height * 0.005,
                            left: index == 0
                                ? -width * 0.0525
                                : index == 1
                                    ? -width * 0.03
                                    : index == 2
                                        ? -width * 0.015
                                        : width * 0.025,
                            child: Column(
                              children: [
                                isImproved
                                    ? Icon(
                                        Icons.arrow_upward_rounded,
                                        color: Colors.green.shade800,
                                        size: index < 3
                                            ? aspectRatio * 40
                                            : aspectRatio * 35,
                                      )
                                    : const SizedBox(),
                                ...List.generate(
                                  index < 3 ? 3 : 2,
                                  (cIndex) => Container(
                                    width: 3,
                                    height: 10.0 - (cIndex * 2),
                                    margin:
                                        EdgeInsets.only(bottom: height * 0.005),
                                    decoration: BoxDecoration(
                                      color: isImproved
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                !isImproved
                                    ? Icon(
                                        Icons.arrow_downward_rounded,
                                        color: Colors.red.shade800,
                                        size: index < 3
                                            ? aspectRatio * 40
                                            : aspectRatio * 35,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
