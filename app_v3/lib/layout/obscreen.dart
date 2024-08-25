import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_shifter.dart';
import '../components/on_boarding/Bubble.dart';
import '../components/on_boarding/DATA.dart';
import '../components/on_boarding/NavigatorIndicator.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/size_data.dart';

class OBScreen extends ConsumerStatefulWidget {
  const OBScreen({super.key});

  @override
  ConsumerState<OBScreen> createState() => _OBScreenState();
}

class _OBScreenState extends ConsumerState<OBScreen> {
  int currentView = 0; // Tracks the current page view
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0); // Initialize PageController
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose PageController to free resources
    super.dispose();
  }

  // Set 'isFirstTimeView' to false and navigate to AuthShifter
  Future<void> setIsFirstTimeView() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isFirstTimeView', false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthShifter()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    // Helper function to get font color with opacity
    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.04),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/OB_bg2.jpg"),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              opacity: .6,
            ),
          ),
          child: Column(
            children: [
              // Navigator indicator
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      3,
                      (index) => NavigatorIndicator(
                            width: width,
                            height: height,
                            index: index,
                            isSelected: currentView == index,
                          )),
                ),
              ),
              SizedBox(height: height * 0.02),
              // Page view for onboarding screens
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
                        child: SizedBox(
                          width: width * .8,
                          child: Text(
                            headerText[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamilyENUM.IstokWeb.name,
                              fontWeight: FontWeight.bold,
                              fontSize: sizeData.superLarge,
                              color: fontColor(.8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                                height: height * .3,
                              ),
                              ...bubbleGenerator(height, width, 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 'Get Started' button
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
                        primaryColors[0],
                      ],
                    ),
                  ),
                  child: Text(
                    "GET STARTED",
                    style: TextStyle(
                      fontFamily: FontFamilyENUM.IstokWeb.name,
                      fontWeight: FontWeight.w700,
                      fontSize: sizeData.header,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  // Generates a list of bubble widgets with random positions and colors
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
