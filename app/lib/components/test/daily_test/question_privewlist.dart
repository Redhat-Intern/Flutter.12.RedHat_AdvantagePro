import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/test.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';


class QuestionPreviewList extends ConsumerStatefulWidget {
  const QuestionPreviewList({
    super.key,
    required this.testFields,
    required this.testIndex,
    required this.setIndex,
    required this.answerList,
  });

  final List<TestField> testFields;
  final int testIndex;
  final Function setIndex;
  final List<String?> answerList;

  @override
  ConsumerState<QuestionPreviewList> createState() =>
      _QuestionPreviewListState();
}

class _QuestionPreviewListState extends ConsumerState<QuestionPreviewList> {
  final ScrollController _controller = ScrollController();

  @override
  void didUpdateWidget(QuestionPreviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testIndex != widget.testIndex) {
      double itemWidth = MediaQuery.of(context).size.width * 0.25;
      double scrollOffset = itemWidth * widget.testIndex;
      setState(() {
        _controller.animateTo(
          scrollOffset,
          curve: Curves.ease,
          duration: Durations.medium4,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SizedBox(
      height: height * 0.05,
      child: ListView.builder(
        controller: _controller,
        padding: EdgeInsets.symmetric(vertical: height * 0.002),
        scrollDirection: Axis.horizontal,
        itemCount: widget.testFields.length,
        itemBuilder: (context, index) {
          bool isSelected = index == widget.testIndex;
          return GestureDetector(
            onTap: () => widget.setIndex(index),
            child: AnimatedContainer(
              duration: Durations.medium4,
              margin: EdgeInsets.only(right: width * 0.03),
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? colorData.primaryColor(.8)
                    : widget.answerList[index] != null
                        ? Colors.green
                        : colorData.secondaryColor(.5),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: widget.testFields[index].question.substring(0, 10),
                size: sizeData.regular,
                weight: FontWeight.w800,
                color: isSelected || widget.answerList[index] != null
                    ? colorData.sideBarTextColor(1)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
