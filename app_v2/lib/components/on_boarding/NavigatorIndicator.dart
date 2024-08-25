import 'package:flutter/material.dart';

import '../../utilities/static_data.dart';

class NavigatorIndicator extends StatelessWidget {
  final double width;
  final double height;
  final int index;
  final bool isSelected;

  const NavigatorIndicator({
    required this.width,
    required this.height,
    required this.index,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 6,
      width: width * 0.2,
      margin: EdgeInsets.only(
        top: height * 0.03,
        left: index == 0 ? width * 0.05 : 0.0,
        right: index == 2 ? width * 0.05 : 0.0,
        bottom: height * 0.03,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColors[0]
            : const Color.fromARGB(255, 17, 18, 35).withOpacity(.15),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
