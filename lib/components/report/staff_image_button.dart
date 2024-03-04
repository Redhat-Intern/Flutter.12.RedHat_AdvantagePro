import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class StaffImageButton extends ConsumerWidget {
  const StaffImageButton({
    super.key,
    required this.todo,
    required this.imageUrl,
  });

  final Function todo;
  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () => todo(),
      child: Container(
        width: aspectRatio * 115,
        height: aspectRatio * 115,
        margin: EdgeInsets.only(
          right: width * 0.04,
        ),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colorData.secondaryColor(1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Shimmer.fromColors(
                  baseColor: colorData.backgroundColor(.1),
                  highlightColor: colorData.secondaryColor(.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorData.secondaryColor(.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
