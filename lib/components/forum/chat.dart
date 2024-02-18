import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';
import 'chatting_page.dart';

class Chat extends ConsumerWidget {
  const Chat({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChattingPage()),
        );
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: height * 0.01),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorData.secondaryColor(1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/staff1.png",
                      height: aspectRatio * 90,
                      width: aspectRatio * 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "RHCSA001",
                        weight: FontWeight.w800,
                        size: sizeData.medium,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      CustomText(
                        text: "The last chat made in the group ",
                        weight: FontWeight.w600,
                        size: sizeData.verySmall,
                        color: colorData.fontColor(.6),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(aspectRatio * 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colorData.primaryColor(.3),
                            colorData.primaryColor(1),
                          ],
                        ),
                      ),
                      child: CustomText(
                        text: "3",
                        color: colorData.secondaryColor(1),
                        weight: FontWeight.w700,
                      ),
                    ),
                    CustomText(
                      text: "2 min",
                      weight: FontWeight.w800,
                      color: colorData.fontColor(.8),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: height * 0.0125,
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    colorData.fontColor(.2),
                    Colors.transparent,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
