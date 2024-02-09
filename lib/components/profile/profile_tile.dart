import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../common/icon.dart';
import '../common/text.dart';

class ProfileTile extends ConsumerWidget {
  final String text;
  final IconData icon;
  final Function todo;
  const ProfileTile({
    super.key,
    required this.todo,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () => todo(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorData.secondaryColor(.6),
        ),
        height: height * 0.065,
        // color: Colors.amber,
        margin: EdgeInsets.symmetric(horizontal: width * 0.14),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: CustomIcon(
                size: aspectRatio * 50,
                icon: icon,
                color: colorData.fontColor(.8),
              ),
            ),
            CustomText(
              text: text,
              size: sizeData.medium,
              color: colorData.fontColor(.8),
            ),
          ],
        ),
      ),
    );
  }
}
