import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnderMaintenance extends ConsumerWidget {
  const UnderMaintenance({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 36),
              child: SvgPicture.asset(
                "assets/images/mascot/zigzag.svg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  "assets/images/mascot/gears_with_ripple.png",
                  height: MediaQuery.of(context).size.height / 3,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  child: const Text(
                    "We are working on it!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  child: const Text(
                    "Our servers are under maintenance. Please try again in a few minutes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
