import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/notification_data_provider.dart';

import '../../model/notification.dart';
import '../../utilities/static_data.dart';

int updateNotificationData(
    {required WidgetRef ref,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> data,
    required String email}) {
  List<NotificationData> notificationData = [];
  int messageCount = 0;
  for (QueryDocumentSnapshot<Map<String, dynamic>> allNotifications in data) {
    switch (allNotifications.id) {
      case "all":
        break;
      case "invitations":
        List<Map<String, dynamic>> notificationList = [];
        for (MapEntry<String, dynamic> individualData
            in allNotifications.data().entries) {
          if (individualData.key.toLowerCase() == email.toLowerCase()) {
            Map.from(individualData.value).forEach((key, value) {
              notificationList.add({
                "batch": key,
                "message": value["message"],
              });
              messageCount += 1;
            });
          }
        }
        notificationData.add(NotificationData(
            category: NotificationsCategory.batches,
            notifications: notificationList));
        break;
      case "staffs":
        break;
      case "students":
        break;
    }
  }
  Future(() => ref
      .read(notificationDataProvider.notifier)
      .setNotificationData(notificationData));
  return messageCount;
}
