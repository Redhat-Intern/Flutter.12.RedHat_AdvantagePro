import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'back_button.dart';
import 'menu_button.dart';
import 'text.dart';

class PageHeader extends ConsumerWidget {
  const PageHeader({
    super.key,
    required this.tittle,
    required this.isMenuButton,
    this.secondaryWidget,
    this.otherMethod,
  });

  final String tittle;
  final bool isMenuButton;
  final Widget? secondaryWidget;
  final Function? otherMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: CustomText(
            text: tittle.toUpperCase(),
            size: sizeData.header,
            color: colorData.fontColor(1),
            weight: FontWeight.w600,
            height: 2,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: isMenuButton
              ? const MenuButton()
              : CustomBackButton(otherMethod: otherMethod),
        ),
        secondaryWidget != null
            ? Positioned(right: 0, child: secondaryWidget!)
            : const SizedBox()
      ],
    );
  }
}
