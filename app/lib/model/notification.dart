import 'package:redhat_v1/utilities/static_data.dart';

class NotificationData {
  NotificationsCategory category;
  List<Map<String, dynamic>> notifications;
  NotificationData({required this.category, required this.notifications});
}
