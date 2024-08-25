import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/text.dart';
import '../functions/firebase_auth.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class UserNotfound extends ConsumerWidget {
  const UserNotfound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/PNF1.png",
                height: height * .3,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomText(
                text: "OOPS!!",
                align: TextAlign.center,
                size: sizeData.superHeader,
                fontFamily: "Merriweather",
                weight: FontWeight.w900,
                color: Colors.red,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomText(
                text: "YOU HAVE BEEN REMOVED FROM\n THE ORGANIZATION",
                align: TextAlign.center,
                size: sizeData.medium,
                height: 1.75,
                maxLine: 2,
              ),
              SizedBox(
                height: height * 0.08,
              ),
              GestureDetector(
                onTap: () {
                  AuthFB().currentUser!.delete();
                  AuthFB().signOut(ref: ref);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.125, vertical: height * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorData.secondaryColor(.8)),
                    gradient: LinearGradient(
                      colors: [
                        colorData.secondaryColor(.2),
                        colorData.secondaryColor(.6),
                      ],
                    ),
                  ),
                  child: CustomText(
                    text: "try again".toUpperCase(),
                    color: colorData.fontColor(1),
                    size: sizeData.header,
                    weight: FontWeight.bold,
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
}
