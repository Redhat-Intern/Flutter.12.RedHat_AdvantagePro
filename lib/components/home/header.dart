import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../../providers/drawer_provider.dart';

import '../common/icon.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<ScaffoldState> scaffoldKey = ref.read(DrawerKeyNotifier);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Row(
      children: [
        GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: Container(
            padding: EdgeInsets.all(aspectRatio * 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(aspectRatio * 14),
              color: colorData.sideBarColor,
            ),
            child: CustomIcon(
              icon: Icons.menu_rounded,
              color: colorData.sideBarTextColor(.85),
              size: aspectRatio * 40,
            ),
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CustomIcon(
              size: aspectRatio * 55,
              icon: Icons.notifications_outlined,
              color: colorData.fontColor(.8),
            ),
            Positioned(
              top: -6,
              left: -1,
              child: Container(
                padding: EdgeInsets.all(aspectRatio * 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorData.sideBarColor,
                ),
                child: CustomText(
                  text: "2",
                  size: aspectRatio * 18,
                  color: colorData.sideBarTextColor(1),
                  weight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Container()
      ],
    );
  }
}
