// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/static_data.dart';

class NotificationsCategoryNotifier
    extends StateNotifier<NotificationsCategory> {
  NotificationsCategoryNotifier() : super(NotificationsCategory.invitations);

  void changeCategory(NotificationsCategory category) {
    state = category;
  }
}

final notificationsCategoryProvider =
    StateNotifierProvider<NotificationsCategoryNotifier, NotificationsCategory>(
        (ref) => NotificationsCategoryNotifier());
