import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LoaderBalls extends ConsumerWidget {
  const LoaderBalls({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: colorData.secondaryColor(.5),
        highlightColor: colorData.secondaryColor(1),
        child: Container(
          height: aspectRatio * 25,
          width: aspectRatio * 25,
          margin: EdgeInsets.symmetric(horizontal: width * 0.02),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorData.secondaryColor(1),
          ),
        ),
      ),
    );
  }
}
