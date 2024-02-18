import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/icon.dart';
import '../components/common/text.dart';
import '../components/forum/chat.dart';
import '../components/forum/forum_header.dart';
import '../providers/forum_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/menu_button.dart';

class Forum extends ConsumerWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ForumCategory category = ref.watch(forumCategoryProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
          children: [
            const MenuButton(),
            const Spacer(),
            CustomText(
              text: "FORUM",
              size: sizeData.header,
              color: colorData.fontColor(1),
              weight: FontWeight.w600,
            ),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: height * 0.02,
        ),
        const ForumHeader(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Chat(
                data: {},
              );
            },
          ),
        ),
      ],
    );
  }
}
