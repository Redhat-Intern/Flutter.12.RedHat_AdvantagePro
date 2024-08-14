import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';

class ShimmerBox extends ConsumerWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);

    return Shimmer.fromColors(
      baseColor: colorData.secondaryColor(.5),
      highlightColor: colorData.secondaryColor(1),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: colorData.secondaryColor(1)),
      ),
    );
  }
}
