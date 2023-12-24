import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';

class StaffCertificatesTile extends ConsumerWidget {
  const StaffCertificatesTile({
    super.key,
    required this.value,
    required this.field,
  });
  final String field;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.005),
      child: Row(
        children: [
          CustomText(
            text: field,
            size: sizeData.small,
            color: colorData.fontColor(.5),
            weight: FontWeight.w600,
          ),
          SizedBox(
            width: width * 0.5,
            child: CustomText(
              text: value,
              size: sizeData.regular,
              color: colorData.fontColor(.8),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
