import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';
import 'text.dart';

class CustomNetworkImage extends ConsumerWidget {
  const CustomNetworkImage({
    super.key,
    this.url,
    required this.size,
    required this.radius,
    this.border,
    this.padding,
    this.backgroundColor,
    this.rightMargin,
    this.bottomMargin,
    this.textSize,
    this.fit,
    this.height,
  });
  final String? url;
  final double size;
  final double radius;
  final double? height;
  final double? textSize;
  final Color? backgroundColor;
  final Border? border;
  final double? padding;

  final double? rightMargin;
  final double? bottomMargin;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);

    return Container(
      height: height ?? size,
      width: height != null ? null : size,
      margin: EdgeInsets.only(
        right: rightMargin != null ? rightMargin! : 0,
        bottom: bottomMargin != null ? bottomMargin! : 0,
      ),
      padding: EdgeInsets.all(padding ?? 2.5),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorData.secondaryColor(1),
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: url != null && url!.isNotEmpty
          ? url!.length == 1
              ? CustomText(
                  text: url!,
                  size: textSize,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.network(
                    url!,
                    height: height ?? size,
                    width: height != null ? null : size,
                    fit: fit ?? BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Shimmer.fromColors(
                          baseColor: colorData.backgroundColor(.1),
                          highlightColor: colorData.secondaryColor(.1),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: colorData.secondaryColor(.5),
                              borderRadius: BorderRadius.circular(radius),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
          : Shimmer.fromColors(
              baseColor: colorData.backgroundColor(.1),
              highlightColor: colorData.secondaryColor(.1),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.5),
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
    );
  }
}
