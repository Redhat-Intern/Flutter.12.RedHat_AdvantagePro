// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/notification.dart';

class NotificationDataNotifier extends StateNotifier<List<NotificationData>> {
  NotificationDataNotifier() : super([]);

  void setNotificationData(List<NotificationData> data) {
    state = data;
  }
}

final notificationDataProvider =
    StateNotifierProvider<NotificationDataNotifier, List<NotificationData>>(
        (ref) => NotificationDataNotifier());


