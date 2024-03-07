import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class HoldPage extends ConsumerWidget {
  const HoldPage({
    super.key,
    this.fromDaily,
  });
  final String? fromDaily;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Column(
      children: [
        SizedBox(
          height: height * 0.04,
        ),
        Align(
          alignment: Alignment.center,
          child: CustomText(
            text: fromDaily ?? "Waiting for Others",
            size: sizeData.header,
            color: colorData.fontColor(.8),
            weight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Image.asset(
          "assets/images/start_test.png",
          width: width,
          fit: BoxFit.fitWidth,
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
