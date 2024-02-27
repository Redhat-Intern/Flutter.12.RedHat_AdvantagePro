import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        Spacer(),
        Container(
          margin: EdgeInsets.only(right: width * 0.02),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorData.secondaryColor(1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: imageURL.length == 1
                ? Container(
                    height: aspectRatio * 70,
                    width: aspectRatio * 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorData.primaryColor(.4),
                          colorData.primaryColor(.9),
                        ],
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        text: imageURL.toUpperCase(),
                        size: aspectRatio * 50,
                        weight: FontWeight.bold,
                        color: colorData.secondaryColor(1),
                      ),
                    ),
                  )
                : Image.network(
                    imageURL,
                    height: aspectRatio * 70,
                    width: aspectRatio * 70,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Shimmer.fromColors(
                          baseColor: colorData.backgroundColor(.1),
                          highlightColor: colorData.secondaryColor(.1),
                          child: Container(
                            height: aspectRatio * 70,
                            width: aspectRatio * 70,
                            decoration: BoxDecoration(
                              color: colorData.secondaryColor(.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
