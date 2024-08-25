import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

import 'feedback_chart.dart';

class FeedbackReport extends ConsumerWidget {
  const FeedbackReport({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Feedback",
                size: sizeData.subHeader,
                weight: FontWeight.w800,
                color: colorData.fontColor(.8),
              ),
              CustomText(
                text: "1. RHCSE001",
                size: sizeData.medium,
                weight: FontWeight.w800,
                color: colorData.fontColor(.6),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const FeedbackChart(),
        ],
      ),
    );
  }
}
