import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../utilities/theme/theme_provider.dart';

import '../common/icon.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<ThemeMode, Color> themeMap = ref.watch(themeProvider);
    ThemeProviderNotifier notifier = ref.read(themeProvider.notifier);

    bool isDark = themeMap.keys.first == ThemeMode.dark;

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double aspectRatio = sizeData.aspectRatio;
    return GestureDetector(
      onTap: () {
        notifier.toggleThemeMode(!isDark);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: CustomIcon(
          size: aspectRatio * 100,
          icon: isDark ? Icons.light_mode_rounded : Icons.nights_stay_rounded,
          color: colorData.fontColor(.8),
        ),
      ),
    );
  }
}
