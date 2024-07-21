import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/auth/loginsingup_shifter.dart';
import '../../components/common/back_button.dart';
import '../../components/common/footer.dart';
import '../../utilities/console_logger.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../functions/firebase_auth.dart';

import '../../components/auth/logintext_field.dart';
import '../../components/common/text.dart';
import '../../layout/auth.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool forgetPassword = false;
  bool showPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void resetPassword({
    required double textSize,
    required Color textColor,
    required Color backgroundColor,
  }) async {
    try {
      await AuthFB().sendPasswordResetEmail(email: emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: CustomText(
            text: "Password Reset Email has been sent !",
            maxLine: 3,
            align: TextAlign.center,
            color: textColor,
            size: textSize,
            weight: FontWeight.w600,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: backgroundColor,
            content: CustomText(
              text: "No user found for that email.",
              maxLine: 3,
              align: TextAlign.center,
              color: textColor,
              size: textSize,
              weight: FontWeight.w600,
            ),
          ),
        );
      }
    }
  }

  void loginUser({
    required double textSize,
    required Color textColor,
    required Color backgroundColor,
  }) {
    AuthFB()
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((v){
      Navigator.pop(context);
    })
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

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    return Scaffold(
      backgroundColor: const Color(0xffDADEEC),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: height * 0.02,
              left: width * 0.04,
              child: const CustomBackButton(
                tomove: MainAuthPage(),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image(
                height: height * .185,
                image: const AssetImage(
                  "assets/images/redhat.png",
                ),
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
                    text: forgetPassword ? "Forget Password" : "Login",
                    size: sizeData.superHeader,
                    color: fontColor(1),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomText(
                    text: forgetPassword
                        ? "Please enter your email Id"
                        : "Please signin in to continue",
                    size: sizeData.header,
                    color: fontColor(.6),
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
                  forgetPassword == false
                      ? LoginTextField(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          isVisible: showPassword,
                          icon: Icons.password_rounded,
                          labelText: "PASSWORD",
                          suffixIconData: showPassword == true
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          controller: passwordController,
                          bottomMargin: 0.01,
                        )
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          forgetPassword = !forgetPassword;
                        });
                      },
                      child: CustomText(
                        text: forgetPassword
                            ? "Back to login"
                            : "Forget Password ?",
                        size: sizeData.medium,
                        color: primaryColors[0].withOpacity(.7),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (forgetPassword) {
                        resetPassword(
                          textColor: fontColor(.8),
                          textSize: sizeData.regular,
                          backgroundColor: secondaryColor(1),
                        );
                        ConsoleLogger.sent("Password reset email sent",
                            from: "resetPassword");
                      } else {
                        loginUser(
                          textColor: fontColor(.8),
                          textSize: sizeData.regular,
                          backgroundColor: secondaryColor(1),
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.04),
                        padding: EdgeInsets.symmetric(vertical: height * .0125),
                        width: width * 0.325,
                        decoration: BoxDecoration(
                          color: primaryColors[0].withOpacity(1),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColors[0].withOpacity(.2),
                              blurRadius: 12,
                              offset: const Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: primaryColors[0].withOpacity(.2),
                              blurRadius: 16,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          weight: FontWeight.bold,
                          text: forgetPassword ? "SEND EMAIL" : "LOGIN",
                          size: sizeData.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const LoginSingupShifter(shifter: LoginSignup.login),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
