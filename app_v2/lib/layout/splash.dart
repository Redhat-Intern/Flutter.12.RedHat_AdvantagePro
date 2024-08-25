import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Image.asset(
          "assets/gif/splash_screen2.gif",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
