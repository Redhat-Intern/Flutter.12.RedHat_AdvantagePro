import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class BatchReportResult extends ConsumerWidget {
  const BatchReportResult({
    super.key,
    required this.header,
    required this.value,
    this.widgetValue,
  });
  final String header;
  final String value;
  final Widget? widgetValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    

    return Padding(
      padding: EdgeInsets.only(bottom: height*0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            text: header,
            color: colorData.fontColor(.6),
            weight: FontWeight.w700,
          ),
          SizedBox(
            width: width * 0.01,
          ),
          widgetValue ??
              CustomText(
                text: value,
                color: colorData.fontColor(.9),
                weight: FontWeight.w800,
                size: sizeData.medium,
              ),
        ],
      ),
    );
  }
}
