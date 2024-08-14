import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class StaffImageButton extends ConsumerWidget {
  const StaffImageButton({
    super.key,
    required this.todo,
    required this.imageUrl,
    required this.name,
    this.isAdmin = false,
  });

  final Function todo;
  final String imageUrl;
  final String name;
  final bool? isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
        onTap: () => todo(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomNetworkImage(
              size: height * 0.065,
              radius: 8,
              url: imageUrl,
              rightMargin: width * 0.03,
            ),
            Positioned(
              bottom: -(height * (isAdmin! ? .015 : 0.008)),
              left: -2,
              child: SizedBox(
                width: height * .07,
                child: CustomText(
                  text: name.toUpperCase(),
                  size: aspectRatio * 16,
                  align: TextAlign.center,
                ),
              ),
            ),
          ],
        ));
  }
}
