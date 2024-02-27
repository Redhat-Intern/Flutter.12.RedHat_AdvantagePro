// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/forum.dart';

class ForumDataNotifier extends StateNotifier<List<ChatForum>> {
  ForumDataNotifier() : super([]);

  void updateChatForum(List<ChatForum> data) {
    state = data;
  }
}

final forumDataProvider =
    StateNotifierProvider<ForumDataNotifier, List<ChatForum>>(
        (ref) => ForumDataNotifier());
