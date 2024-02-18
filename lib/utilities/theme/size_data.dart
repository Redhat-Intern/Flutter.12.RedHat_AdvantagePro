import 'package:flutter/material.dart';

class CustomSizeData {
  final double height;
  final double width;
  final double aspectRatio;

  final double superHeader;
  final double superLarge;
  final double header;
  final double subHeader;
  final double medium;
  final double regular;
  final double small;
  final double verySmall;
  final double tooSmall;

  final double sideBarWith;

  // Color Data

  factory CustomSizeData.from(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    double superLarge = aspectRatio * 55;
    double superHeader = aspectRatio * 45;
    double header = aspectRatio * 40;
    double subHeader = aspectRatio * 36;
    double medium = aspectRatio * 34;
    double regular = aspectRatio * 30;
    double small = aspectRatio * 27;
    double verySmall = aspectRatio * 24;
    double tooSmall = aspectRatio * 22;

    double sideBarWidth = width * 0.65;

    return CustomSizeData(
      height: height,
      width: width,
      aspectRatio: aspectRatio,
      sideBarWith: sideBarWidth,
      superHeader: superHeader,
      superLarge: superLarge,
      header: header,
      medium: medium,
      regular: regular,
      small: small,
      subHeader: subHeader,
      verySmall: verySmall,
      tooSmall: tooSmall,
    );
  }

  CustomSizeData({
    required this.height,
    required this.width,
    required this.aspectRatio,
    required this.superHeader,
    required this.superLarge,
    required this.header,
    required this.subHeader,
    required this.medium,
    required this.regular,
    required this.small,
    required this.verySmall,
    required this.tooSmall,
    required this.sideBarWith,
  });
}
