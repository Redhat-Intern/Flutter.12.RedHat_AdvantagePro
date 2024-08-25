import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../functions/update/update_notification_data.dart';
import '../../model/user.dart';
import '../../pages/profile.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../pages/notification.dart';
import '../common/icon.dart';
import '../common/menu_button.dart';
import '../common/network_image.dart';
import '../common/text.dart';
import '../common/waiting_widgets/notification_waiting.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    UserModel userData = ref.watch(userDataProvider);
    String name = userData.name;
    String role = userData.userRole!.displayName;

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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("notifications")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                      snapshot.data!.docs.toList();
                  int messageCount = updateNotificationData(
                      ref: ref, data: data, email: userData.email);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Notifications(),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomIcon(
                          size: aspectRatio * 65,
                          icon: Icons.notifications_outlined,
                          color: colorData.fontColor(.8),
                        ),
                        Positioned(
                          top: -10,
                          left: -2,
                          child: Container(
                            padding: EdgeInsets.all(aspectRatio * 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorData.primaryColor(1),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: messageCount.toString(),
                              size: aspectRatio * 22,
                              color: colorData.sideBarTextColor(1),
                              weight: FontWeight.bold,
                              align: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const NotificationWaitingWidget();
                }
              },
            ),
            SizedBox(width: width * 0.02),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              child: CustomNetworkImage(
                size: aspectRatio * 80,
                radius: 8,
                padding: 1.5,
                url: userData.imagePath == '' ? null : userData.imagePath,
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.015,
        ),
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
                SizedBox(
                  width: width * .6,
                  child: CustomText(
                    text: name.isEmpty
                        ? name
                        : name[0].toUpperCase() + name.substring(1),
                    size: sizeData.header,
                    color: colorData.fontColor(.8),
                    weight: FontWeight.bold,
                  ),
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
