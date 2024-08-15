import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/back_button.dart';
import '../../common/network_image.dart';
import '../../common/text.dart';

class ChatFieldHeader extends ConsumerWidget {
  const ChatFieldHeader({
    super.key,
    required this.name,
    required this.imageURL,
    this.status,
    this.liveCount,
  });
  final String name;
  final String imageURL;
  final Status? status;
  final int? liveCount;

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
                if (status != null)
                  CustomText(
                    text: status!.name,
                    size: sizeData.small,
                    color:
                        colorData.fontColor(status == Status.online ? .8 : .5),
                    weight: FontWeight.w800,
                  ),
                if (liveCount != null)
                  CustomText(
                    text: liveCount!.toString(),
                    size: sizeData.small,
                    color:
                        colorData.fontColor(status == Status.online ? .8 : .5),
                    weight: FontWeight.w800,
                  ),
                if (liveCount != null) SizedBox(width: width * 0.01),
                if (liveCount != null)
                  CustomText(
                    text: Status.online.name,
                    size: sizeData.small,
                    color:
                        colorData.fontColor(status == Status.online ? .8 : .5),
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
