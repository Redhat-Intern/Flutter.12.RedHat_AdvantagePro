import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class StaffsListWaiting extends ConsumerWidget {
  const StaffsListWaiting({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

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
          height: height * .02,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width * .02),
            ShimmerBox(height: aspectRatio * 80, width: aspectRatio * 80),
            SizedBox(width: width * .04),
            ShimmerBox(height: aspectRatio * 110, width: aspectRatio * 110),
            SizedBox(width: width * .04),
            Opacity(
                opacity: .5,
                child: ShimmerBox(
                    height: aspectRatio * 110, width: aspectRatio * 110)),
            SizedBox(width: width * .04),
            Opacity(
                opacity: .3,
                child: ShimmerBox(
                    height: aspectRatio * 110, width: aspectRatio * 110)),
          ],
        )
      ],
    );
  }
}
