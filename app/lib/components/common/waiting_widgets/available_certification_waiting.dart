import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class AvailableCertificationWaitingWidget extends ConsumerWidget {
  const AvailableCertificationWaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          height: sizeData.subHeader,
          width: width * .35,
        ),
        SizedBox(
          height: height * .015,
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
              ShimmerBox(
                height: sizeData.medium,
                width: width * .2,
              ),
              SizedBox(height: height * .01),
              Row(
                children: [
                  ShimmerBox(
                    height: height * .12,
                    width: height * .12,
                  ),
                  SizedBox(
                    width: width * .04,
                  ),
                  Opacity(
                    opacity: .5,
                    child: ShimmerBox(
                      height: height * .12,
                      width: height * .12,
                    ),
                  ),
                  SizedBox(
                    width: width * .04,
                  ),
                  Opacity(
                    opacity: .2,
                    child: ShimmerBox(
                      height: height * .12,
                      width: height * .12,
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
