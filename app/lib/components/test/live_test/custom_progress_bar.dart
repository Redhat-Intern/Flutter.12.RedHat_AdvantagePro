import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/test.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';
import '../../common/text.dart';

class CustomProgressBar extends ConsumerStatefulWidget {
  const CustomProgressBar(
      {super.key, required this.seconds, required this.testData});

  final int seconds;
  final TestField testData;

  @override
  ConsumerState<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends ConsumerState<CustomProgressBar>
    with TickerProviderStateMixin {
  late AnimationController controller;

  void toUpdate() {
    if (mounted) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CustomProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testData != widget.testData) {
      toUpdate();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.005),
                height: sizeData.superLarge,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: colorData.secondaryColor(.3), width: 3),
                ),
              ),
              Container(
                height: sizeData.superLarge,
                width: controller.value * (width),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    colorData.primaryColor(1),
                    colorData.primaryColor(.6),
                  ]),
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: colorData.secondaryColor(.3), width: 3),
                ),
              ),
              Positioned(
                left: width * 0.04,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CustomText(
                    text:
                        (controller.value * widget.seconds).toStringAsFixed(4),
                    size: sizeData.subHeader,
                    color: colorData.sideBarTextColor(1),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: width * 0.015,
                top: 0,
                bottom: 0,
                child: CustomIcon(
                  size: aspectRatio * 40,
                  icon: Icons.timer_outlined,
                  color: controller.value > .9
                      ? colorData.sideBarTextColor(1)
                      : colorData.primaryColor(.8),
                ),
              )
            ],
          );
        });
  }
}
