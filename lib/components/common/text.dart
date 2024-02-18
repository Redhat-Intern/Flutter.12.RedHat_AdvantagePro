import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

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
    this.weight = FontWeight.w600,
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
    double fontSize = sizeData.regular;
    double width = sizeData.width;
    return !loadingState
        ? Text(
            text,
            textAlign: align,
            maxLines: maxLine,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: size ?? fontSize,
              fontWeight: weight,
              color: color ?? colorData.fontColor(.8),
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
