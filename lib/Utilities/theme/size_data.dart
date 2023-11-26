import 'package:flutter/material.dart';

class CustomSizeData {
  final double height;
  final double width;
  final double aspectRatio;

  final double headerSize;
  final double subHeaderSize;
  final double textSize;
  final double smallTextSize;

  final double sizeBarWith;

  // Color Data

  factory CustomSizeData.from(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    double headerSize = aspectRatio * 40;
    double subHeaderSize = aspectRatio * 35;
    double textSize = aspectRatio * 30;
    double smallTextSize = aspectRatio * 25;

    double sideBarWidth = width * 0.65;

    return CustomSizeData(
      height: height,
      width: width,
      aspectRatio: aspectRatio,
      sizeBarWith: sideBarWidth,
      headerSize: headerSize,
      smallTextSize: smallTextSize,
      subHeaderSize: subHeaderSize,
      textSize: textSize,
    );
  }

  CustomSizeData({
    required this.height,
    required this.width,
    required this.aspectRatio,
    required this.headerSize,
    required this.subHeaderSize,
    required this.textSize,
    required this.smallTextSize,
    required this.sizeBarWith,
  });
}
