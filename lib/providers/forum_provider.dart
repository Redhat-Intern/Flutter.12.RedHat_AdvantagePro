// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../model/forum.dart';

class ForumDataNotifier
    extends StateNotifier<MapEntry<List<ChatForum>, Map<String, Status>>> {
  ForumDataNotifier() : super(const MapEntry([], {}));

  void updateChatForum(List<ChatForum> data) {
    state = MapEntry(data, state.value);
  }

  void updateStatus(Map<String, bool> data) {
    state = MapEntry(
        state.key,
        data.map((key, value) =>
            MapEntry(key, value ? Status.online : Status.offline)));
  }
}

final forumDataProvider = StateNotifierProvider<ForumDataNotifier,
        MapEntry<List<ChatForum>, Map<String, Status>>>(
    (ref) => ForumDataNotifier());
