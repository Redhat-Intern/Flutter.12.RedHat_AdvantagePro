import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';

class BatchButton extends ConsumerWidget {
  const BatchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.008,
            horizontal: width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorData.primaryColor(.4),
                colorData.primaryColor(1),
              ],
            ),
          ),
          child: CustomText(
            text: "Create Batch",
            size: sizeData.regular,
            color: colorData.fontColor(1),
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: width * 0.14,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.008,
            horizontal: width * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorData.secondaryColor(.2),
                colorData.secondaryColor(.8),
              ],
            ),
          ),
          child: CustomText(
            text: "Save Batch",
            size: sizeData.regular,
            color: colorData.fontColor(.8),
            weight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
