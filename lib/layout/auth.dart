import 'package:flutter/material.dart';

import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';

import '../components/common/icon.dart';
import '../components/common/text.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

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
                    size: sizeData.superHeader,
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
                        size: aspectRatio * 32,
                        color: colorData.primaryColor(.7),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.04),
                      padding: EdgeInsets.symmetric(vertical: height * .0125),
                      width: width * 0.35,
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
                        size: aspectRatio * 35,
                        color: Colors.white,
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

class LoginTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final double bottomMargin;
  const LoginTextField({
    super.key,
    required this.labelText,
    required this.icon,
    required this.controller,
    required this.bottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(bottom: height * bottomMargin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white54),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: aspectRatio * 40,
          color: colorData.fontColor(.8),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          prefixIcon: CustomIcon(
            icon: icon,
            color: colorData.fontColor(.8),
            size: aspectRatio * 55,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: aspectRatio * 34,
            color: colorData.fontColor(.7),
          ),
        ),
      ),
    );
  }
}
