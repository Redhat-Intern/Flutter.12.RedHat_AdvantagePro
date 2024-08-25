import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/test.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';
import '../../common/text.dart';

class IndexShifters extends ConsumerWidget {
  const IndexShifters({
    super.key,
    required this.testIndex,
    required this.testFields,
    required this.toBack,
    required this.toNext,
    required this.submitTest,
  });

  final int testIndex;
  final List<TestField> testFields;
  final Function toBack;
  final Function toNext;
  final Function submitTest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    bool isLast = testIndex == testFields.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => toBack(),
          child: Opacity(
            opacity: testIndex == 0 ? .5 : 1,
            child: Container(
              padding: EdgeInsets.only(
                right: width * 0.04,
                left: width * 0.02,
                top: height * 0.01,
                bottom: height * 0.01,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorData.secondaryColor(.5),
              ),
              child: Row(
                children: [
                  CustomIcon(
                      size: sizeData.aspectRatio * 50,
                      icon: Icons.arrow_back_ios_rounded,
                      color: colorData.fontColor(.6)),
                  SizedBox(width: width * 0.02),
                  CustomText(
                      text: "BACK",
                      size: sizeData.medium,
                      weight: FontWeight.w800),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => isLast ? submitTest() : toNext(),
          child: Container(
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * (isLast ? .04 : 0.02),
              top: height * 0.01,
              bottom: height * 0.01,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.primaryColor(.8),
            ),
            child: Row(
              children: [
                CustomText(
                  text: isLast ? "SUBMIT" : "NEXT",
                  size: sizeData.medium,
                  weight: FontWeight.w800,
                  color: colorData.sideBarTextColor(1),
                ),
                SizedBox(width: isLast ? 0 : width * 0.02),
                isLast
                    ? const SizedBox()
                    : CustomIcon(
                        size: sizeData.aspectRatio * 50,
                        icon: Icons.arrow_forward_ios_rounded,
                        color: colorData.sideBarTextColor(1),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
