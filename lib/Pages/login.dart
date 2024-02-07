import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
            top: height * 0.04,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Hello,",
                    color: colorData.fontColor(.6),
                    weight: FontWeight.w600,
                    size: sizeData.superHeader,
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  CustomText(
                    text: "Welcome Back!",
                    color: colorData.fontColor(.8),
                    weight: FontWeight.w800,
                    size: sizeData.superLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
