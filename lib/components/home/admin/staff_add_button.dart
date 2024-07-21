import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pages/add_pages/add_staff.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';

class StaffAddButton extends ConsumerWidget {
  const StaffAddButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddStaff(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        margin: EdgeInsets.only(right: width * 0.02, left: width * 0.01),
        decoration: BoxDecoration(
          color: colorData.secondaryColor(1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIcon(
          size: aspectRatio * 60,
          icon: Icons.add_rounded,
          color: colorData.fontColor(.7),
        ),
      ),
    );
  }
}
