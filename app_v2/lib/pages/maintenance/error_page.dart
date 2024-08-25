import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../functions/firebase_auth.dart';
import '../../model/app_state.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/restart_provider.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppState appState = ref.watch(appStateProvider);

    bool isMaintananceError =
        appState.errorMessage.toString().toLowerCase() == "connection refused";
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
                    "Something doesn't seem right",
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
                  child: Text(
                    isMaintananceError
                        ? "Our servers are under maintenance. Please try again in a few minutes"
                        : appState.errorMessage.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (isMaintananceError) {
                        ref.read(restartProvider.notifier).restart();
                      } else {
                        AuthFB().signOut(ref: ref);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        isMaintananceError ? "Try again" : "Login Again",
                        style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
