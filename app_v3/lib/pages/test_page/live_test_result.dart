import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/network_image.dart';
import '../../components/common/page_header.dart';
import '../../components/common/text.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestResult extends ConsumerStatefulWidget {
  const LiveTestResult({
    super.key,
    required this.dayIndex,
    required this.batchName,
    this.day,
    this.popMethod,
  });

  final String dayIndex;
  final String batchName;
  final String? day;
  final Function? popMethod;

  @override
  ConsumerState<LiveTestResult> createState() => _LiveTestResultState();
}

class _LiveTestResultState extends ConsumerState<LiveTestResult>
    with WidgetsBindingObserver {
  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter.play();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("liveTest")
                .doc(widget.batchName)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<String, dynamic> data = snapshot.data!.data()!;

              // Map<String, dynamic> answers =
              //     Map<String, dynamic>.from(data[widget.dayIndex]["answers"]);

              Map<String, dynamic> totoalScores = Map<String, dynamic>.from(
                  data[widget.dayIndex]["totalScores"]);

              List<MapEntry<String, dynamic>> totalScoresList =
                  totoalScores.entries.toList();

              totalScoresList
                  .sort((a, b) => (b.value as int).compareTo(a.value));

              Map<String, dynamic> studentsData =
                  Map<String, dynamic>.from(data[widget.dayIndex]["students"]);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PageHeader(
                    tittle: "LIVE TEST RESULT",
                    isMenuButton: false,
                    secondaryWidget: widget.day != null
                        ? CustomText(
                            text: widget.day!,
                            size: sizeData.medium,
                            color: colorData.fontColor(.6),
                            weight: FontWeight.w800,
                            height: 2,
                          )
                        : null,
                    otherMethod: widget.popMethod,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ConfettiWidget(
                        createParticlePath: drawStar,
                        canvas: Size(width, height),
                        shouldLoop: false,
                        confettiController: _controllerTopCenter,
                        blastDirectionality: BlastDirectionality.explosive,
                        maxBlastForce: 2,
                        minBlastForce: 1,
                        emissionFrequency: 0.04,
                        numberOfParticles: 1,
                        // a lot of particles at once
                        gravity: 0.3,
                        child: SizedBox(
                          height: height * 0.03,
                        ),
                      ),
                      ConfettiWidget(
                        canvas: Size(width, height),
                        shouldLoop: false,
                        confettiController: _controllerTopCenter,
                        blastDirectionality: BlastDirectionality.explosive,
                        maxBlastForce: 2,
                        minBlastForce: 1,
                        emissionFrequency: 0.04,
                        numberOfParticles: 1,
                        // a lot of particles at once
                        gravity: 0.3,
                        child: SizedBox(
                          height: height * 0.03,
                        ),
                      ),
                      ConfettiWidget(
                        maximumSize: const Size(20, 15),
                        createParticlePath: drawStar,
                        shouldLoop: false,
                        confettiController: _controllerTopCenter,
                        blastDirectionality: BlastDirectionality.explosive,
                        maxBlastForce: 2,
                        minBlastForce: 1,
                        emissionFrequency: 0.03,
                        numberOfParticles: 2,
                        // a lot of particles at once
                        gravity: 0.8,
                        child: SizedBox(
                          height: height * 0.03,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        totoalScores.length >= 3
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: height * 0.005),
                                    child: CustomNetworkImage(
                                      size: aspectRatio * 125,
                                      radius: 50,
                                      url: studentsData[totalScoresList[2].key]
                                          ["photo"],
                                      textSize: sizeData.superLarge,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .175,
                                    child: CustomText(
                                      text: studentsData[totalScoresList[2].key]
                                          ["name"],
                                      size: sizeData.verySmall,
                                      maxLine: 2,
                                      align: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: width * .175,
                                    height: height * .1,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      color: colorData.primaryColor(.4),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: "3",
                                          size: aspectRatio * 65,
                                          color: Colors.white,
                                          weight: FontWeight.w900,
                                        ),
                                        SizedBox(height: height * 0.01),
                                        CustomText(
                                          text: totalScoresList[2]
                                              .value
                                              .toString(),
                                          color: Colors.white.withOpacity(.8),
                                          weight: FontWeight.w900,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(width: width * 0.015),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.005),
                              child: CustomNetworkImage(
                                size: aspectRatio * 125,
                                radius: 50,
                                url: studentsData[totalScoresList[0].key]
                                    ["photo"],
                                textSize: sizeData.superLarge,
                              ),
                            ),
                            SizedBox(
                              width: width * .175,
                              child: CustomText(
                                text: studentsData[totalScoresList[0].key]
                                    ["name"],
                                size: sizeData.verySmall,
                                align: TextAlign.center,
                                maxLine: 2,
                              ),
                            ),
                            Container(
                              width: width * .175,
                              height: height * .2,
                              margin: EdgeInsets.only(top: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: colorData.primaryColor(1),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "1",
                                    size: aspectRatio * 80,
                                    color: Colors.white,
                                    weight: FontWeight.w900,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  CustomText(
                                    text: totalScoresList[0].value.toString(),
                                    color: Colors.white.withOpacity(.8),
                                    weight: FontWeight.w900,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.015),
                        totoalScores.length >= 2
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: height * 0.005),
                                    child: CustomNetworkImage(
                                      size: aspectRatio * 125,
                                      radius: 50,
                                      url: studentsData[totalScoresList[1].key]
                                          ["photo"],
                                      textSize: sizeData.superLarge,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * .175,
                                    child: CustomText(
                                      text: studentsData[totalScoresList[1].key]
                                          ["name"],
                                      size: sizeData.verySmall,
                                      align: TextAlign.center,
                                      maxLine: 2,
                                    ),
                                  ),
                                  Container(
                                    width: width * .175,
                                    height: height * .15,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      color: colorData.primaryColor(.7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: "2",
                                          size: aspectRatio * 70,
                                          color: Colors.white,
                                          weight: FontWeight.w900,
                                        ),
                                        SizedBox(height: height * 0.02),
                                        CustomText(
                                          text: totalScoresList[1]
                                              .value
                                              .toString(),
                                          color: Colors.white.withOpacity(.8),
                                          weight: FontWeight.w900,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: totalScoresList.length,
                      itemBuilder: (context, index) {
                        return ResultTile(
                          index: (index + 1).toString(),
                          name: studentsData[totalScoresList[index].key]
                              ["name"],
                          imageURL: studentsData[totalScoresList[index].key]
                              ["photo"],
                          points: totalScoresList[index].value.toString(),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResultTile extends ConsumerWidget {
  const ResultTile({
    super.key,
    required this.index,
    required this.name,
    required this.imageURL,
    required this.points,
  });

  final String index;
  final String name;
  final String imageURL;
  final String points;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.025,
      ),
      child: Row(
        children: [
          CustomText(
            text: index,
            color: colorData.fontColor(.4),
            weight: FontWeight.w700,
          ),
          Container(
            height: aspectRatio * 95,
            width: aspectRatio * 95,
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.03),
            padding: EdgeInsets.all(aspectRatio * 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorData.secondaryColor(1),
              border: Border.all(color: colorData.primaryColor(.3), width: 2),
            ),
            alignment: Alignment.center,
            child: imageURL.length == 1
                ? CustomText(
                    text: imageURL,
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w800,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(imageURL),
                  ),
          ),
          CustomText(
            text: name,
            size: sizeData.subHeader,
            weight: FontWeight.w700,
          ),
          const Spacer(),
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
              text: "$points pt",
              size: sizeData.medium,
              color: colorData.primaryColor(.8),
              weight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
