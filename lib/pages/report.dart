import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/menu_button.dart';
import '../components/common/text.dart';
import '../components/report/batch_report.dart';
import '../components/report/feedback_report.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Report extends ConsumerWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Column(
      children: [
        Row(
          children: [
            const MenuButton(),
            const Spacer(),
            CustomText(
              text: "REPORT",
              size: sizeData.header,
              color: colorData.fontColor(1),
              weight: FontWeight.w600,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            CustomText(
              text: "18.01.2024",
              size: sizeData.medium,
              color: colorData.fontColor(.6),
              weight: FontWeight.w800,
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: height*0.04,),
        const FeedbackReport(),
        SizedBox(height: height*0.04,),
        const BatchReport(),
      ],
    );
  }
}
