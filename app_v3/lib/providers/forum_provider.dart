import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/forum.dart';
import '../utilities/static_data.dart';

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
