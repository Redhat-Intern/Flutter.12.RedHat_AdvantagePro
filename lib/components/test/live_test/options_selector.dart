import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/test.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';

class OptionsSelector extends ConsumerStatefulWidget {
  const OptionsSelector({
    super.key,
    required this.currentTestField,
    required this.setOption,
  });

  final TestField currentTestField;
  final Function setOption;

  @override
  ConsumerState<OptionsSelector> createState() => _OptionsSelectorState();
}

class _OptionsSelectorState extends ConsumerState<OptionsSelector> {
  String yourAnswer = "";

  @override
  void didUpdateWidget(covariant OptionsSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTestField != oldWidget.currentTestField) {
      setState(() {
        yourAnswer = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);


    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Expanded(
        child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: widget.currentTestField.options.entries.map((e) {
        bool isSelected = yourAnswer == e.key;
        return GestureDetector(
          onTap: () {
            setState(() {
              yourAnswer = e.key;
            });
            widget.setOption(e);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: height * 0.02),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: !isSelected
                  ? colorData.secondaryColor(.3)
                  : colorData.primaryColor(.8),
            ),
            child: Row(children: [
              Container(
                height: aspectRatio * 60,
                width: aspectRatio * 60,
                margin: EdgeInsets.only(right: width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorData.backgroundColor(1),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  text: e.key,
                  size: sizeData.subHeader,
                  weight: FontWeight.bold,
                  color: colorData.fontColor(.7),
                ),
              ),
              CustomText(
                text: e.value,
                size: sizeData.subHeader,
                color: isSelected
                    ? colorData.sideBarTextColor(1)
                    : colorData.fontColor(.6),
                weight: FontWeight.w800,
                maxLine: 3,
              ),
            ]),
          ),
        );
      }).toList(),
    ));
  }
}
