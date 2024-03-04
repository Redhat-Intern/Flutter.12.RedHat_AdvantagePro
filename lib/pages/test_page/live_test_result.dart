import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestResult extends ConsumerWidget {
  const LiveTestResult({
    super.key,
    required this.dayIndex,
    required this.batchName,
    required this.day,
  });
  final int dayIndex;
  final String batchName;
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
                  .collection("liveTest")
                  .doc(batchName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map<String, dynamic> data = snapshot.data!.data()!;

                return Column(
                  children: [
                    Row(
                      children: [
                        const CustomBackButton(),
                        const Spacer(
                          flex: 2,
                        ),
                        CustomText(
                          text: "LIVE TEST RESULT",
                          size: sizeData.header,
                          color: colorData.fontColor(1),
                          weight: FontWeight.w600,
                        ),
                        const Spacer(),
                        CustomText(
                          text: day,
                          size: sizeData.medium,
                          color: colorData.fontColor(.6),
                          weight: FontWeight.w800,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(aspectRatio * 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorData.secondaryColor(1),
                                ),
                                child: ClipOval(
                                    // child: Image.network(""),
                                    ),
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          return ResultTile(
                              index: index.toString(),
                              name: "name",
                              imageURL: "N",
                              points: "763");
                        },
                      ),
                    ),
                    ResultTile(
                        index: "2",
                        name: "Bharathraj",
                        imageURL: "B",
                        points: "1221"),
                  ],
                );
              }),
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
            color: colorData.fontColor(.6),
            weight: FontWeight.w700,
          ),
          Container(
            height: aspectRatio * 80,
            width: aspectRatio * 80,
            padding: EdgeInsets.all(aspectRatio * 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorData.secondaryColor(1),
            ),
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
            size: sizeData.medium,
            weight: FontWeight.w700,
          ),
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

class _CustomRectanglePainter extends CustomPainter {
  final double width;
  final double height;
  final Color color;

  _CustomRectanglePainter({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    // Draw the rectangle with a curved top-left corner
    path.moveTo(0, height);
    path.lineTo(
        0, size.height * 0.2); // Adjust the height based on your desired curve
    path.quadraticBezierTo(width * 0.1, size.height * 0.1, width * 0.3,
        size.height * 0.1); // Adjust control points for curve shape
    path.lineTo(width, size.height * 0.1);
    path.lineTo(width, height);
    path.close();

    // Fill the path with the specified color
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CustomRectanglePainter oldDelegate) =>
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      height != oldDelegate.height;
}
