import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class RecentWaitingWidget extends ConsumerWidget {
  const RecentWaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerBox(
              height: sizeData.subHeader,
              width: width * .3,
            ),
            ShimmerBox(
              height: sizeData.subHeader,
              width: width * .1,
            )
          ],
        ),
        SizedBox(
          height: height * .01,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * .04, vertical: height * 0.015),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorData.secondaryColor(.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerBox(
                    height: sizeData.subHeader,
                    width: width * .2,
                  ),
                  SizedBox(width: width * .04),
                  ShimmerBox(
                    height: sizeData.subHeader,
                    width: width * .15,
                  ),
                  SizedBox(width: width * .01),
                  ShimmerBox(
                    height: sizeData.subHeader,
                    width: width * .05,
                  ),
                ],
              ),
              SizedBox(height: height * .02),
              Row(
                children: [
                  ShimmerBox(
                    height: height * 0.125,
                    width: height * .125,
                  ),
                  SizedBox(
                    width: width * .04,
                  ),
                  Opacity(
                    opacity: .5,
                    child: ShimmerBox(
                      height: height * 0.125,
                      width: height * .125,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
