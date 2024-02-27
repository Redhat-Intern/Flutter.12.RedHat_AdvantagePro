import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class WorkTilePlaceHolder extends ConsumerWidget {
  const WorkTilePlaceHolder({
    super.key,
    required this.header,
    required this.toGO,
    required this.value,
    required this.placeholder,
  });

  final String header;
  final String value;
  final Widget toGO;
  final String placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: "${header.toUpperCase()}:",
              color: colorData.fontColor(.5),
              weight: FontWeight.w800,
              size: sizeData.small,
            ),
            SizedBox(
              width: width * 0.01,
            ),
            CustomText(
              text: value.toUpperCase(),
              color: Colors.red,
              weight: FontWeight.w800,
              size: sizeData.regular,
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => toGO,
            ),
          ),
          child: Container(
            width: width,
            height: height * 0.0525,
            padding: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
              top: height * 0.006,
              bottom: height * 0.006,
            ),
            decoration: BoxDecoration(
              color: colorData.backgroundColor(.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Center(
              child: CustomText(
                text: placeholder,
                color: colorData.fontColor(.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
