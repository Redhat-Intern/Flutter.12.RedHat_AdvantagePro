import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

class NotificationWaitingWidget extends ConsumerWidget {
  const NotificationWaitingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    return Shimmer.fromColors(
      baseColor: colorData.secondaryColor(.5),
      highlightColor: colorData.secondaryColor(1),
      child: Icon(
        Icons.notifications_rounded,
        size: sizeData.aspectRatio * 70,
        color: colorData.secondaryColor(1),
      ),
    );
  }
}
