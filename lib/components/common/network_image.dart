import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';

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
  });
  final String? url;
  final double size;
  final double radius;
  final double? textSize;
  final Color? backgroundColor;
  final Border? border;
  final double? padding;

  final double? rightMargin;
  final double? bottomMargin;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);

    return Container(
      height: size,
      width: size,
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
      alignment: Alignment.center,
      child: url != null
          ? url!.length == 1
              ? CustomText(
                  text: url!,
                  size: textSize,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Image.network(
                    url!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
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
