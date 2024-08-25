import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/auth_pages/login.dart';
import '../../pages/auth_pages/signup.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class LoginSingupShifter extends ConsumerWidget {
  const LoginSingupShifter({
    super.key,
    required this.shifter,
  });
  final LoginSignup shifter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: shifter == LoginSignup.signup
              ? "Already have a account,"
              : "Don't have a account,",
          weight: FontWeight.w700,
          color: fontColor(.6),
          size: sizeData.regular,
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => shifter == LoginSignup.signup
                  ? const Login()
                  : const Signup(),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: width * 0.02),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.008,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor(.5)),
            child: CustomText(
              text: shifter == LoginSignup.signup ? "LOGIN" : "SIGNUP",
              weight: FontWeight.bold,
              size: sizeData.medium,
              color: primaryColors[0],
            ),
          ),
        ),
      ],
    );
  }
}
