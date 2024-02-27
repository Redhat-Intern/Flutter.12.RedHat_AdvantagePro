// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BatchSelectNotifier extends StateNotifier<String> {
  BatchSelectNotifier() : super("");

  void updateChatForum(String data) {
    state = data;
  }
}

final forumDataProvider =
    StateNotifierProvider<BatchSelectNotifier, String>(
        (ref) => BatchSelectNotifier());
