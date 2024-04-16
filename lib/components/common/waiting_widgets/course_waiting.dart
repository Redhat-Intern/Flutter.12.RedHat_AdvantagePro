import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class CourseContentWaitingWidget extends ConsumerWidget {
  const CourseContentWaitingWidget({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.0175),
          ShimmerBox(height: sizeData.superHeader, width: width * .25),
          SizedBox(height: height * 0.015),
          Container(
            height: height * .055,
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.04,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.secondaryColor(.15),
            ),
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              itemBuilder: ((context, index) => Padding(
                    padding: EdgeInsets.only(right: width * 0.03),
                    child:
                        ShimmerBox(height: sizeData.header, width: width * .15),
                  )),
            ),
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025, vertical: height * 0.015),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(height: sizeData.header, width: width * .15),
                      const Spacer(),
                      ShimmerBox(
                          height: sizeData.superLarge, width: width * .65),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      ShimmerBox(height: sizeData.header, width: width * .18),
                      const Spacer(),
                      ShimmerBox(height: height * .06, width: width * .6),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  ShimmerBox(height: sizeData.header, width: width * .15),
                  SizedBox(height: height * 0.015),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      children: List.generate(
                        2,
                        (index) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          margin: EdgeInsets.only(bottom: height * 0.015),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorData.backgroundColor(.5),
                                colorData.backgroundColor(.1),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              ShimmerBox(
                                height: aspectRatio * 120,
                                width: aspectRatio * 120,
                              ),
                              SizedBox(width: width * 0.02),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerBox(
                                    width: width * 0.5,
                                    height: height * 0.02,
                                  ),
                                  SizedBox(height: height * 0.015),
                                  ShimmerBox(
                                    width: width * 0.2,
                                    height: height * 0.02,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
