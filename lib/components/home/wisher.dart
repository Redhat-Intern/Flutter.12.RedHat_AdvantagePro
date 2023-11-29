import 'package:flutter/material.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

class Wisher extends StatelessWidget {
  Wisher({super.key});
  String name = "Harish";
  String role = "Student";

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double height = sizeData.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Welcome",
              size: sizeData.regular,
              color: colorData.fontColor(.6),
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: height * 0.002,
            ),
            CustomText(
              text: name,
              size: sizeData.header,
              color: colorData.fontColor(.8),
              weight: FontWeight.bold,
            ),
          ],
        ),
        CustomText(
          text: role.toUpperCase(),
          size: sizeData.regular,
          color: colorData.fontColor(.7),
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}
