import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class Wisher extends ConsumerWidget {
  const Wisher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = ref.watch(userDataProvider);
    String name = userData["name"];
    String role = userData["role"];

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Welcome",
              size: sizeData.regular,
              color: colorData.fontColor(.6),
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: height * 0.002,
            ),
            CustomText(
              text: name,
              size: sizeData.header,
              color: colorData.fontColor(.8),
              weight: FontWeight.bold,
            ),
          ],
        ),
        CustomText(
          text: role.toUpperCase(),
          size: sizeData.regular,
          color: colorData.fontColor(.7),
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}
