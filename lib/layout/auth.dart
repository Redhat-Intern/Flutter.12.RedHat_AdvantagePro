import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_auth.dart';
import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';

import '../components/auth/logintext_field.dart';
import '../components/common/text.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser(
      {required double textSize,
      required Color textColor,
      required Color backgroundColor}) {
    AuthFB()
        .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
        .then((value) {})
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: CustomText(
            text: error.message.toString(),
            maxLine: 3,
            align: TextAlign.center,
            color: textColor,
            size: textSize,
            weight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    // double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image(
                height: height * .185,
                image: const AssetImage("assets/images/redhat.png"),
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: height * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Login",
                    size: sizeData.superHeader,
                    color: colorData.fontColor(1),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomText(
                    text: "Please signin in to continue",
                    size: sizeData.header,
                    color: colorData.fontColor(.6),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  LoginTextField(
                    icon: Icons.email_outlined,
                    labelText: "EMAIL",
                    controller: emailController,
                    bottomMargin: 0.025,
                  ),
                  LoginTextField(
                    icon: Icons.password_rounded,
                    labelText: "PASSWORD",
                    controller: passwordController,
                    bottomMargin: 0.01,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: CustomText(
                        text: "Forget Password",
                        size: sizeData.medium,
                        color: colorData.primaryColor(.7),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => loginUser(
                      textColor: colorData.fontColor(.8),
                      textSize: sizeData.regular,
                      backgroundColor: colorData.secondaryColor(1),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.04),
                        padding: EdgeInsets.symmetric(vertical: height * .0125),
                        width: width * 0.325,
                        decoration: BoxDecoration(
                          color: colorData.primaryColor(1),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: colorData.primaryColor(.2),
                              blurRadius: 12,
                              offset: const Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: colorData.primaryColor(.2),
                              blurRadius: 16,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          weight: FontWeight.bold,
                          text: "LOGIN",
                          size: sizeData.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
