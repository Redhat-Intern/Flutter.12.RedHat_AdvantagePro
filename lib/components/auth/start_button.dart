import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/auth_pages/login.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class StartButton extends ConsumerWidget {
  const StartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.15),
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(153, 240, 240, 246),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomText(text: " 🥳 ", size: sizeData.header),
            ShaderMask(
              shaderCallback: (Rect rect) => const LinearGradient(colors: [
                Color(0XFF5D44F8),
                Colors.blue,
              ]).createShader(rect),
              child: CustomText(
                text: "Lets get started!",
                size: sizeData.header,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            CustomText(text: " 🚀 ", size: sizeData.header),
          ],
        ),
      ),
    );
  }
}
