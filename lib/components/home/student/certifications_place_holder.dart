import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class CertificationsPlaceHolder extends ConsumerWidget {
  const CertificationsPlaceHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Certifications",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * 0.0125,
        ),
        Container(
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
              Expanded(
                child: CustomText(
                  text: "You have not been enroled in any certified courses till NOW!",
                  maxLine: 2,
                  weight: FontWeight.bold,
                  color: colorData.fontColor(.6),
                  size: sizeData.regular,
                  align: TextAlign.center,
                ),
              ),
              Image.asset(
                "assets/icons/DNF1.png",
                height: height * 0.1,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                width: width * 0.02,
              ),

            ],
          ),
        ),
      ],
    );
  }
}
