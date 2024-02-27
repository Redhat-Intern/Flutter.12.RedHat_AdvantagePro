import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/forum_category_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';

class CategorySelection extends ConsumerWidget {
  const CategorySelection({
    super.key,
    required this.category,
    required this.icon,
    required this.onDone,
  });
  final ForumCategory category;
  final IconData icon;
  final Function onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ForumCategory category = ref.watch(forumCategoryProvider);
    bool isSelected = category == this.category;
    Function changeCategory =
        ref.read(forumCategoryProvider.notifier).changeCategory;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () {
        changeCategory(this.category);
        onDone();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            CustomIcon(
              size: aspectRatio * 50,
              icon: icon,
              color: colorData.fontColor(isSelected ? 1 : .5),
            ),
            SizedBox(
              height: height * 0.005,
            ),
            SizedBox(
              width: width * 0.15,
              child: CustomText(
                text: this.category.name.toUpperCase(),
                size: sizeData.tooSmall,
                weight: FontWeight.w800,
                color: colorData.fontColor(isSelected ? 1 : .5),
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
