import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../common/text.dart';

class StaffsListPlaceHolder extends ConsumerWidget {
  const StaffsListPlaceHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      padding: EdgeInsets.only(
        top: height * 0.015,
        bottom: height * 0.01,
        left: width * 0.02,
      ),
      decoration: BoxDecoration(
        color: colorData.secondaryColor(.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/left.png",
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: CustomText(
              text: "Add your staff to create batch!",
              maxLine: 2,
              weight: FontWeight.bold,
              color: colorData.fontColor(.6),
              size: sizeData.regular,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
