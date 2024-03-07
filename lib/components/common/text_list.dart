import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'text.dart';

class CustomListText extends ConsumerWidget {
  const CustomListText({
    super.key,
    required this.data,
    this.todo,
    this.index,
    required this.getChild,
    this.fromHeight,
    this.highlightColor,
    this.fontSize,
    this.verticalPadding,
    this.horizontalPadding,
    this.backGroundColor,
    this.placeholder,
  });

  final List data;
  final Function? todo;
  final int? index;
  final Function getChild;
  final Color? highlightColor;
  final Color? backGroundColor;
  final double? fontSize;
  final double? fromHeight;
  final double? verticalPadding;
  final double? horizontalPadding;
  final String? placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;
    return Container(
      width: width,
      height: fromHeight ?? height * 0.06,
      padding: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        top: height * 0.006,
        bottom: height * 0.006,
      ),
      decoration: BoxDecoration(
        color: backGroundColor ?? colorData.secondaryColor(.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: data.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? height * 0.005,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, currentIndex) {
                return GestureDetector(
                  onTap: todo != null ? () => todo!(currentIndex) : () {},
                  child: Container(
                    margin: EdgeInsets.only(right: width * 0.03),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? width * 0.02,
                      vertical: height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: colorData.secondaryColor(.4),
                    ),
                    child: Center(
                      child: CustomText(
                        text: getChild(currentIndex),
                        size: fontSize ?? sizeData.regular,
                        color: todo != null
                            ? index == currentIndex
                                ? highlightColor ?? colorData.primaryColor(.8)
                                : colorData.fontColor(.4)
                            : colorData.fontColor(.6),
                        weight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CustomText(
                text: placeholder!,
                weight: FontWeight.w700,
                color: colorData.fontColor(.5),
              ),
            ),
    );
  }
}
