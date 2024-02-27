// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/static_data.dart';

class ForumCategoryNotifier extends StateNotifier<ForumCategory> {
  ForumCategoryNotifier() : super(ForumCategory.all);

  void changeCategory(ForumCategory category) {
    state = category;
  }
}

final forumCategoryProvider =
    StateNotifierProvider<ForumCategoryNotifier, ForumCategory>(
        (ref) => ForumCategoryNotifier());


