import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class NoInternet extends ConsumerWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/MT1.png",
                height: height * .4,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomText(
                text: "OOPS!!\nN0 INTERNET",
                align: TextAlign.center,
                size: sizeData.superHeader,
                height: 2,
                maxLine: 2,
              ),
              SizedBox(
                height: height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
