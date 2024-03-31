import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class WorkTileContainer extends ConsumerWidget {
  const WorkTileContainer({
    super.key,
    this.text,
    this.textWidget,
  });

  final String? text;
  final CustomText? textWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Container(
      width: width,
      height: height * 0.0525,
      padding: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        top: height * 0.006,
        bottom: height * 0.006,
      ),
      alignment: Alignment.center,
      child: textWidget ??
          CustomText(
            text: text!,
            color: colorData.fontColor(.4),
          ),
    );
  }
}
