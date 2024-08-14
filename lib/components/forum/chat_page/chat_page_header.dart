import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/back_button.dart';
import '../../common/text.dart';

class ChatFieldHeader extends ConsumerWidget {
  const ChatFieldHeader({
    super.key,
    required this.name,
    required this.imageURL,
    required this.status,
  });
  final String name;
  final String imageURL;
  final Status status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomBackButton(),
        SizedBox(width: width * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: name,
              size: sizeData.subHeader,
              color: colorData.fontColor(.8),
              weight: FontWeight.w800,
            ),
            Row(
              children: [
                Container(
                  width: aspectRatio * 15,
                  height: aspectRatio * 15,
                  margin: EdgeInsets.only(right: width * 0.01),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == Status.online
                        ? Colors.green
                        : colorData.fontColor(.2),
                  ),
                ),
                CustomText(
                  text: status.name,
                  size: sizeData.small,
                  color: colorData.fontColor(status == Status.online ? .8 : .5),
                  weight: FontWeight.w800,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        CustomNetworkImage(
          size: aspectRatio * 100,
          radius: 8,
          padding: 1.5,
          url: imageURL,
        )
      ],
    );
  }
}
