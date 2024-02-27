import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/notifications/invitation.dart';
import '../model/notification.dart';
import '../providers/notification_data_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/user_select_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/notifications/category_selector.dart';
import '../components/common/back_button.dart';
import '../components/common/text.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({super.key});

  @override
  ConsumerState<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {
  @override
  Widget build(BuildContext context) {
    NotificationsCategory category = ref.watch(notificationsCategoryProvider);
    List<NotificationData> refNotificationData =
        ref.watch(notificationDataProvider);
    Iterable<NotificationData> notificationData =
        refNotificationData.where((element) {
      return element.category == category;
    });
    List<Map<String, dynamic>> data =
        notificationData.isEmpty ? [] : notificationData.first.notifications;

    UserRole userRole = ref.watch(userRoleProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(),
                  CustomText(
                    text: "Notifications",
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
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.0125,
                  horizontal: width * 0.01,
                ),
                margin: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                    bottom: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorData.secondaryColor(.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userRole != UserRole.admin
                        ? const CategorySelector(
                            category: NotificationsCategory.invitations,
                            icon: Icons.all_inbox_rounded,
                          )
                        : const SizedBox(),
                    userRole != UserRole.admin
                        ? const CategorySelector(
                            category: NotificationsCategory.admin,
                            icon: Icons.person_rounded,
                          )
                        : const CategorySelector(
                            category: NotificationsCategory.staffs,
                            icon: Icons.groups_2_rounded,
                          ),
                    const CategorySelector(
                      category: NotificationsCategory.batches,
                      icon: Icons.school_rounded,
                    ),
                    userRole != UserRole.student
                        ? const CategorySelector(
                            category: NotificationsCategory.students,
                            icon: Icons.groups_2_rounded,
                          )
                        : const CategorySelector(
                            category: NotificationsCategory.staffs,
                            icon: Icons.groups_2_rounded,
                          ),
                  ],
                ),
              ),
              Expanded(
                child: data.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InvitationMessage(
                            batchID: data[index]["batch"],
                            message: data[index]["message"],
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const CustomText(
                              text: "No notifications have been received!"),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Image.asset(
                            "assets/images/no_data.png",
                            height: height * 0.45,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
