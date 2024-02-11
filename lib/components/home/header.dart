import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:redhat_v1/pages/profile.dart';

import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../pages/notification.dart';
import '../common/icon.dart';
import '../common/menu_button.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    Map<String, dynamic> userData = ref.watch(userDataProvider);
    String name = userData["name"];
    String role = userData["role"];

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(aspectRatio * 6),
                margin: EdgeInsets.only(left: width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorData.secondaryColor(1),
                ),
                child: Image(
                  height: aspectRatio * 65,
                  width: aspectRatio * 65,
                  image: const AssetImage(
                    "assets/images/redhat.png",
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: height*0.015,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Welcome",
                  size: sizeData.regular,
                  color: colorData.fontColor(.6),
                  weight: FontWeight.w500,
                ),
                SizedBox(
                  height: height * 0.002,
                ),
                CustomText(
                  text: name.isEmpty
                      ? name
                      : name[0].toUpperCase() + name.substring(1),
                  size: sizeData.header,
                  color: colorData.fontColor(.8),
                  weight: FontWeight.bold,
                ),
              ],
            ),
            CustomText(
              text: role.toUpperCase(),
              size: sizeData.regular,
              color: colorData.fontColor(.7),
              weight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
