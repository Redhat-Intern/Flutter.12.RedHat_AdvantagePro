import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:redhat_v1/providers/navigation_index_provider.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../../pages/notification.dart';
import '../common/icon.dart';
import '../common/menu_button.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    // double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const MenuButton(),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Notifications(),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomIcon(
                size: aspectRatio * 65,
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
                    color: colorData.primaryColor(1),
                  ),
                  child: CustomText(
                    text: "2",
                    size: aspectRatio * 22,
                    color: colorData.sideBarTextColor(1),
                    weight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ref.read(navigationIndexProvider.notifier).jumpTo(1);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: EdgeInsets.only(left: width * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.secondaryColor(1),
            ),
            child: Image(
              height: aspectRatio * 60,
              width: aspectRatio * 60,
              image: const AssetImage(
                "assets/images/redhat.png",
              ),
            ),
          ),
        )
      ],
    );
  }
}
