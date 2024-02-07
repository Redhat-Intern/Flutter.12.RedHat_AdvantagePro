import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

class CustomText extends ConsumerWidget {
  final String text;
  final FontWeight weight;
  final double? size;
  final Color? color;
  final double height;
  final TextAlign align;
  final int maxLine;
  final bool loadingState;
  final double length;

  const CustomText({
    super.key,
    required this.text,
    this.weight = FontWeight.w500,
    this.size,
    this.color,
    this.height = 0,
    this.align = TextAlign.start,
    this.maxLine = 1,
    this.loadingState = false,
    this.length = 0.1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    return !loadingState
        ? Text(
            text,
            textAlign: align,
            maxLines: maxLine,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: size,
              fontWeight: weight,
              color: color,
              height: height,
            ),
          )
        : Shimmer.fromColors(
            baseColor: colorData.backgroundColor(.1),
            highlightColor: colorData.secondaryColor(.1),
            child: Container(
              height: size,
              width: length * width,
              decoration: BoxDecoration(
              color: colorData.fontColor(.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
  }
}
