import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';
import '../../common/text.dart';

class DailyTestProgressBar extends ConsumerStatefulWidget {
  const DailyTestProgressBar(
      {super.key, required this.minutes, required this.submitTest});

  final int minutes;
  final Function submitTest;

  @override
  ConsumerState<DailyTestProgressBar> createState() =>
      _DailyTestProgressBarState();
}

class _DailyTestProgressBarState extends ConsumerState<DailyTestProgressBar>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(minutes: widget.minutes),
      vsync: this,
    );
    controller.forward();

    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.submitTest();
      }
    });
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
              width: controller.value * width,
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
                  text: (controller.value * widget.minutes).toStringAsFixed(2),
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
      },
    );
  }
}
