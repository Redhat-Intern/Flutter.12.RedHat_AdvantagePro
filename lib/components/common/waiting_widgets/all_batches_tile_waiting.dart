import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/utilities/theme/color_data.dart';

import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class AllBatchesTileWaitingWidget extends ConsumerWidget {
  const AllBatchesTileWaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(bottom: height * .02),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorData.secondaryColor(.2),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                height: sizeData.medium,
                width: width * .225,
              ),
              SizedBox(
                height: height * .01,
              ),
              ShimmerBox(
                height: aspectRatio * 175,
                width: aspectRatio * 175,
              )
            ],
          ),
          SizedBox(
            width: width * .03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                4,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerBox(
                          height: sizeData.small,
                          width: width * (index%2==0 ? .225: .15),
                        ),
                        SizedBox(width: width * .02),
                        ShimmerBox(
                          height: sizeData.regular,
                          width: width * .175,
                        ),
                      ],
                    ),
                    SizedBox(height: height * .01),
                  ],
                ),
              ),
              Row(
                children: [
                  ShimmerBox(
                    height: sizeData.header,
                    width: width * .2,
                  ),
                  SizedBox(
                    width: width * .04,
                  ),
                  Opacity(
                    opacity: .5,
                    child: ShimmerBox(
                      height: sizeData.header,
                      width: width * .2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
