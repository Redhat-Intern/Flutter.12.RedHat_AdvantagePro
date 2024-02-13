import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../components/common/menu_button.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Forum extends ConsumerWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
          children: [
            const MenuButton(),
            const Spacer(),
            CustomText(
              text: "FORUM",
              size: sizeData.header,
              color: colorData.fontColor(1),
              weight: FontWeight.w600,
            ),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorData.primaryColor(.3),
                      colorData.primaryColor(1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon(
                    size: aspectRatio * 40,
                    icon: Icons.create_new_folder_rounded,
                    color: colorData.secondaryColor(1),
                  ),
                  SizedBox(
                    width: width * .02,
                  ),
                  CustomText(
                    text: "New Group",
                    size: sizeData.regular,
                    weight: FontWeight.w800,
                    color: colorData.secondaryColor(1),
                  )
                ],
              ),
            ),
            Spacer(),
            CustomText(
              text: "ALL",
              size: sizeData.medium,
              color: colorData.fontColor(.6),
              weight: FontWeight.w800,
            ),
            Container(
              padding: EdgeInsets.all(aspectRatio * 16),
              margin: EdgeInsets.only(left: width * 0.04),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIcon(
                icon: Icons.category_rounded,
                color: colorData.fontColor(.6),
                size: aspectRatio * 40,
              ),
            ),
            Container(
              padding: EdgeInsets.all(aspectRatio * 16),
              margin: EdgeInsets.only(left: width * 0.04),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIcon(
                icon: Icons.search_rounded,
                color: colorData.fontColor(.6),
                size: aspectRatio * 40,
              ),
            ),
          ],
        ),
        Container(
          child: Row(
            children: [
              Column(
                children: [
                  CustomIcon(
                    size: aspectRatio * 55,
                    icon: Icons.all_inbox_rounded,
                    color: colorData.fontColor(.6),
                  ),
                  SizedBox(height: height*0.005,),
                  CustomText(
                    text: "ALL",
                    size: sizeData.small,
                    weight: FontWeight.w800,
                    color: colorData.fontColor(.6),
                  ),
                ],
              ),

            ],
          ),
        )
      ],
    );
  }
}
