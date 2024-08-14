import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class BatchList extends ConsumerWidget {
  const BatchList({
    super.key,
    required this.data,
  });
  final List<String> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SizedBox(
      height: height * 0.0325,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(right: width * 0.02),
          padding: EdgeInsets.symmetric(horizontal: width * 0.025),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: colorData.secondaryColor(.4),
          ),
          alignment: Alignment.center,
          child: CustomText(
            text: data[index],
            size: sizeData.small,
            color: colorData.fontColor(.6),
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
