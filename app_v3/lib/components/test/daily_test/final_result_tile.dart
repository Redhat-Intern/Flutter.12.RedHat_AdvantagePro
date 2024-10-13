import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vectra/components/common/network_image.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class FinalResultTile extends ConsumerWidget {
  const FinalResultTile({
    super.key,
    required this.index,
    required this.name,
    required this.imageURL,
    required this.points,
    required this.startTime,
    required this.endTime,
  });

  final int index;
  final String name;
  final String imageURL;
  final String points;
  final DateTime startTime;
  final DateTime endTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    return Container(
      padding: EdgeInsets.only(
        top: height * 0.01,
        bottom: height * 0.01,
        left: width * 0.02,
        right: width * 0.025,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: (index + 1).toString().padLeft(2, " "),
            color: colorData.fontColor(.3),
            weight: FontWeight.w800,
          ),
          SizedBox(width: width * 0.03),
          CustomNetworkImage(
            size: aspectRatio * 110,
            radius: 8,
            url: imageURL,
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: name,
                  size: sizeData.medium,
                  weight: FontWeight.w700,
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text:
                            DateFormat('hh:mm:ss a', 'en_US').format(startTime),
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.6),
                        size: sizeData.small,
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: DateFormat('hh:mm:ss a', 'en_US').format(endTime),
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.6),
                        size: sizeData.small,
                        align: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: width * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.005, horizontal: width * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  colorData.secondaryColor(.4),
                  colorData.secondaryColor(.9),
                ],
              ),
            ),
            child: CustomText(
              text: points,
              size: sizeData.medium,
              color: colorData.primaryColor(1),
              weight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
