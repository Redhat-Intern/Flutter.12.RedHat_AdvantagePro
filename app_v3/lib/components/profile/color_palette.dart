import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../utilities/theme/theme_provider.dart';

class ColorPalette extends ConsumerWidget {
  const ColorPalette({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeProviderNotifier notifier = ref.read(themeProvider.notifier);

    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(
        left: width * 0.15,
        right: width * 0.15,
        bottom: height * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: primaryColors
            .map(
              (e) => GestureDetector(
                onTap: () {
                  notifier.changePrimaryColor(e);
                },
                child: Container(
                  height: aspectRatio * 70,
                  width: aspectRatio * 70,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: e),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
