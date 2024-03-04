import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/text.dart';
import '../utilities/static_data.dart';

import '../components/auth/user_select.dart';
import '../utilities/theme/size_data.dart';
import '../pages/auth_pages/login.dart';

class MainAuthPage extends ConsumerStatefulWidget {
  const MainAuthPage({super.key});

  @override
  ConsumerState<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends ConsumerState<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/login.png",
                height: height * 0.4,
                fit: BoxFit.fitHeight,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: width * .9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Hello,",
                          color: fontColor(.6),
                          weight: FontWeight.w600,
                          size: sizeData.header,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Welcome To ",
                              color: fontColor(.8),
                              weight: FontWeight.w700,
                              size: sizeData.superHeader,
                            ),
                            ShaderMask(
                              shaderCallback: (Rect rect) =>
                                  const LinearGradient(colors: [
                                Color.fromARGB(255, 184, 12, 0),
                                Colors.redAccent
                              ]).createShader(rect),
                              child: CustomText(
                                text: "RedHat!",
                                color: Colors.white,
                                weight: FontWeight.w800,
                                size: sizeData.superHeader,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -12,
                    right: -width * 0.05,
                    child: Image.asset(
                      "assets/images/redhat.png",
                      height: height * 0.1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: CustomText(
                  text:
                      '😉 Embark on a transformative learning voyage with REDHAT, where every click opens doors to new horizons.✌️',
                  size: sizeData.medium,
                  color: fontColor(.6),
                  weight: FontWeight.w700,
                  maxLine: 3,
                  align: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(153, 240, 240, 246),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const UserSelect(
                      togo: Login(),
                      role: UserRole.student,
                      text: "STUDENT",
                      shaderColors: [
                        Color(0XFF5D44F8),
                        Colors.blue,
                      ],
                    ),
                    Transform.rotate(
                      angle: 35,
                      child: Container(
                        height: height * .03,
                        width: 3,
                        decoration: BoxDecoration(
                          color: fontColor(.6),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const UserSelect(
                      togo: Login(),
                      role: UserRole.staff,
                      text: "STAFF",
                      shaderColors: [
                        Color.fromARGB(255, 194, 13, 1),
                        Colors.pink
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UserSelect(
                    togo: const Login(),
                    role: UserRole.admin,
                    size: sizeData.medium,
                    hpad: 0,
                    text: "...for ADMIN",
                    shaderColors: const [
                      Color.fromARGB(255, 194, 13, 1),
                      Colors.pink
                    ],
                  ),
                  CustomText(
                    text: "🥷🏻  ",
                    size: sizeData.medium,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    width: width * .8,
                    height: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(colors: [
                          Colors.white,
                          fontColor(.4),
                          Colors.white
                        ])),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: "By Bharathraj ❤️",
                    color: fontColor(.8),
                    weight: FontWeight.w800,
                  ),
                  SizedBox(
                    height: height * 0.03,
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
