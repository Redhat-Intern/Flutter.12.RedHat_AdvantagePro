import 'package:flutter/material.dart';

class CustomSizeData {
  final double height;
  final double width;
  final double aspectRatio;

  final double superHeader;
  final double header;
  final double subHeader;
  final double medium;
  final double regular;
  final double small;
  final double verySmall;

  final double sideBarWith;

  // Color Data

  factory CustomSizeData.from(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    double superHeader = aspectRatio * 55;
    double header = aspectRatio * 38;
    double subHeader = aspectRatio * 35;
    double medium = aspectRatio * 32;
    double regular = aspectRatio * 29;
    double small = aspectRatio * 26;
    double verySmall = aspectRatio * 24;

    double sideBarWidth = width * 0.65;

    return CustomSizeData(
      height: height,
      width: width,
      aspectRatio: aspectRatio,
      sideBarWith: sideBarWidth,
      superHeader: superHeader,
      header: header,
      medium: medium,
      regular: regular,
      small: small,
      subHeader: subHeader,
      verySmall: verySmall,
    );
  }

  CustomSizeData({
    required this.height,
    required this.width,
    required this.aspectRatio,
    required this.superHeader,
    required this.header,
    required this.subHeader,
    required this.medium,
    required this.regular,
    required this.small,
    required this.verySmall,
    required this.sideBarWith,
  });
}
