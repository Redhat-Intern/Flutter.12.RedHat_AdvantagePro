import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';
import 'notification_waiting.dart';

class MainPageHeaderWaitingWidget extends ConsumerWidget {
  const MainPageHeaderWaitingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerBox(height: aspectRatio * 80, width: aspectRatio * 80),
            const Spacer(),
            const NotificationWaitingWidget(),
            SizedBox(width: width * 0.02),
            ShimmerBox(height: aspectRatio * 80, width: aspectRatio * 80),
          ],
        ),
        SizedBox(height: height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: sizeData.medium, width: width * .2),
                SizedBox(
                  height: height * 0.008,
                ),
                ShimmerBox(height: sizeData.superHeader, width: width * .45),
              ],
            ),
            ShimmerBox(height: sizeData.header, width: width * .15),
          ],
        )
      ],
    );
  }
}
