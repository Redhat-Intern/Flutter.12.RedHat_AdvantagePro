import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/on_boarding/Bubble.dart';
import '../components/on_boarding/DATA.dart';
import '../components/on_boarding/NavigatorIndicator.dart';
import '../providers/app_state_provider.dart';
import '../utilities/routes.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/size_data.dart';

class OBScreen extends ConsumerStatefulWidget {
  const OBScreen({super.key});

  @override
  ConsumerState<OBScreen> createState() => _OBScreenState();
}

class _OBScreenState extends ConsumerState<OBScreen> {
  int currentView = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  setIsFirstTimeView() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(isFirstRun, false);
    ref.read(appStateProvider.notifier).setFirstLoad(state: false);
    GoRouter.of(context).goNamed(Routes.mainAuthName);
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
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(
            top: height * 0.04,
            left: width * 0.04,
            right: width * 0.04,
          ),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 225, 224, 233)
            ],
          )),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavigatorIndicator(
                      width: width,
                      height: height,
                      index: 0,
                      isSelected: currentView == 0,
                    ),
                    NavigatorIndicator(
                      width: width,
                      height: height,
                      index: 1,
                      isSelected: currentView == 1,
                    ),
                    NavigatorIndicator(
                      width: width,
                      height: height,
                      index: 2,
                      isSelected: currentView == 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: 3,
                  onPageChanged: (int value) {
                    setState(() {
                      currentView = value;
                    });
                  },
                  itemBuilder: (context, index) => Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(
                          headerText[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Khyay',
                            fontSize: sizeData.superLarge,
                            color: fontColor(.8),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Stack(children: [
                            Image.asset(
                              imagePaths[index],
                              fit: BoxFit.cover,
                              height: height * .3,
                            ),
                            ...bubbleGenerator(height, width, 4),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: setIsFirstTimeView,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [
                        primaryColors[0].withOpacity(.6),
                        primaryColors[0]
                      ],
                    ),
                  ),
                  child: Text(
                    "GET STARTED",
                    style: TextStyle(
                      fontFamily: 'Khyay',
                      fontWeight: FontWeight.w700,
                      fontSize: sizeData.header,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Bubble> bubbleGenerator(double height, double width, int count) {
    List<Bubble> bubbles = [];
    List<Color> colorList = const [
      Color.fromRGBO(22, 254, 154, 1),
      Color.fromRGBO(255, 135, 120, 1),
      Color.fromRGBO(86, 123, 255, 1),
    ];

    for (int i = 0; i < count; i++) {
      Bubble bubble = Bubble(
        top: height * (0.02 + Random().nextDouble() * 0.25),
        left: width * (0.05 + Random().nextDouble() * 0.8),
        color: colorList[currentView]
            .withOpacity(0.4 + Random().nextDouble() * 0.6),
      );
      bubbles.add(bubble);
    }

    return bubbles;
  }
}
