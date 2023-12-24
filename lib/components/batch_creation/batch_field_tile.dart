import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../common/text.dart';

class BatchFieldTile extends ConsumerWidget {
  const BatchFieldTile({
    super.key,
    required this.field,
    required this.value,
  });

  final String field;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            color: colorData.fontColor(.6),
            size: sizeData.small,
            text: "${field.toUpperCase()}: ",
            weight: FontWeight.w600,
          ),
          CustomText(
            color: colorData.fontColor(.8),
            size: sizeData.regular,
            text: value,
          ),
        ],
      ),
    );
  }
}
