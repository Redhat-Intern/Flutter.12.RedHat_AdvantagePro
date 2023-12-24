import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(aspectRatio * 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(aspectRatio * 14),
          color: colorData.primaryColor(1),
        ),
        child: CustomIcon(
          icon: Icons.arrow_back_ios_new_rounded,
          color: colorData.sideBarTextColor(.85),
          size: aspectRatio * 40,
        ),
      ),
    );
  }
}
