import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class SearchFieldWaitingWidget extends ConsumerWidget {
  const SearchFieldWaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          height: sizeData.subHeader,
          width: width * .45,
        ),
        SizedBox(
          height: height * .01,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * .02, vertical: height * 0.008),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorData.secondaryColor(.3),
          ),
          child: Row(
            children: [
              ShimmerBox(
                height: sizeData.superLarge,
                width: width * .2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
