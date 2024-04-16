// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScrollNotifier extends StateNotifier<ScrollController> {
  ChatScrollNotifier() : super(ScrollController());

  void jump() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state.hasClients) {
        state.jumpTo(state.position.maxScrollExtent);
      }
    });
  }
}

final chatScrollProvider =
    StateNotifierProvider<ChatScrollNotifier, ScrollController>(
        (ref) => ChatScrollNotifier());
