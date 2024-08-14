import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class BatchTileText extends ConsumerWidget {
  const BatchTileText({
    super.key,
    required this.header,
    required this.value,
  });

  final String header;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.005),
      child: Row(
        children: [
          CustomText(
            text: header,
            size: sizeData.verySmall,
            color: colorData.fontColor(.6),
            weight: FontWeight.w700,
          ),
          SizedBox(
            width: width * 0.015,
          ),
          Expanded(
            child: CustomText(
              text: value,
              weight: FontWeight.w800,
            ),
          )
        ],
      ),
    );
  }
}
