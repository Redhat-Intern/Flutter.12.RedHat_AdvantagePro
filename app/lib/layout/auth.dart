import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/auth/start_button.dart';
import '../components/common/text.dart';

import '../utilities/theme/size_data.dart';

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

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        didPop ? exit(1) : exit(0);
      },
      child: Scaffold(
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

                // Button to move to the login page
                const StartButton(),
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
                      text: "By MetaHumans ❤️",
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
      ),
    );
  }
}
