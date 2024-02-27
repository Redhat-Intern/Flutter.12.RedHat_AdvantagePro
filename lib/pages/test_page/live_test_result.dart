import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class LiveTestResult extends ConsumerStatefulWidget {
  const LiveTestResult({
    super.key,
    required this.batchData,
    required this.dayIndex,
    required this.day,
  });
  final int dayIndex;
  final String day;
  final Map<String, dynamic> batchData;

  @override
  ConsumerState<LiveTestResult> createState() => _LiveTestResultState();
}

class _LiveTestResultState extends ConsumerState<LiveTestResult> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  const Spacer(
                    flex: 2,
                  ),
                  CustomText(
                    text: "LIVE TEST RESULT",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                  ),
                  const Spacer(),
                  CustomText(
                    text: widget.day,
                    size: sizeData.medium,
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w800,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
