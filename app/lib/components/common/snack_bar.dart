import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'text.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required String message,
    required SnackBarType type,
  }) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorData.secondaryColor(1),
        content: CustomText(
          text: type == SnackBarType.error
              ? "🤯 $message 🤯"
              : type == SnackBarType.success
                  ? "🤩 $message 🤩"
                  : "✌️ $message ✌️",
          maxLine: 3,
          align: TextAlign.center,
          color: colorData.fontColor(.8),
          size: sizeData.regular,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
