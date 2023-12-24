import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double size;
  final Color color;
  final double height;
  final TextAlign align;
  final int maxLine;

  const CustomText({
    super.key,
    required this.text,
    this.weight = FontWeight.w500,
    required this.size,
    required this.color,
    this.height = 0,
    this.align = TextAlign.start,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
