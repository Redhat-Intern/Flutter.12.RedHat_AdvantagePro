// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/static_data.dart';

class ForumCategoryNotifier
    extends StateNotifier<MapEntry<ForumCategory, String?>> {
  ForumCategoryNotifier() : super(const MapEntry(ForumCategory.all, null));

  void changeCategory(ForumCategory category) {
    state = MapEntry(category, state.value);
  }

  void setSearchString(String searchString) {
    state = MapEntry(state.key, searchString);
  }

  void resetCategory() {
    state = const MapEntry(ForumCategory.all, null);
  }
}

final forumCategoryProvider = StateNotifierProvider<ForumCategoryNotifier,
    MapEntry<ForumCategory, String?>>((ref) => ForumCategoryNotifier());
