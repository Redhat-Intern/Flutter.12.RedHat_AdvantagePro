import 'package:flutter/material.dart';

import 'navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void navigationMethod() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {

        return const Navigation();
      },
    ));
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600), navigationMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
