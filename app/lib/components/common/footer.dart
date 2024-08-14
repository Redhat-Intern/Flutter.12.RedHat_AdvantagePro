import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/size_data.dart';
import 'text.dart';

class Footer extends ConsumerWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);

    return Column(
      children: [
        SizedBox(
          height: height * 0.04,
        ),
        Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          height: 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(colors: [
                const Color(0xffDADEEC),
                fontColor(.4),
                const Color(0xffDADEEC)
              ])),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        CustomText(
          text: "By Bharathraj ❤️",
          color: fontColor(.8),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * 0.03,
        ),
      ],
    );
  }
}
