import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/forum.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';
import 'chatting_page.dart';

class Chat extends ConsumerWidget {
  const Chat({
    super.key,
    required this.data,
    required this.index,
  });

  final ChatForum data;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ChatMessage message = data.messages.last;
    String lastMessage = message.text != null
        ? message.text!
        : message.imageURL != null
            ? "Image is sent .."
            : "File is sent ..";
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChattingPage(index: index)),
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
                    borderRadius: BorderRadius.circular(6),
                    child: data.imageURL.length == 1
                        ? Container(
                            height: aspectRatio * 90,
                            width: aspectRatio * 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorData.primaryColor(.4),
                                  colorData.primaryColor(.9),
                                ],
                              ),
                            ),
                            child: Center(
                              child: CustomText(
                                text: data.imageURL.toUpperCase(),
                                size: aspectRatio * 70,
                                weight: FontWeight.bold,
                                color: colorData.secondaryColor(1),
                              ),
                            ),
                          )
                        : Image.network(
                            data.imageURL,
                            height: aspectRatio * 90,
                            width: aspectRatio * 90,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: colorData.backgroundColor(.1),
                                  highlightColor: colorData.secondaryColor(.1),
                                  child: Container(
                                    height: aspectRatio * 90,
                                    width: aspectRatio * 90,
                                    decoration: BoxDecoration(
                                      color: colorData.secondaryColor(.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.name.toString()[0].toUpperCase() +
                            data.name.toString().substring(1),
                        weight: FontWeight.w800,
                        size: sizeData.medium,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      CustomText(
                        text: lastMessage,
                        weight: FontWeight.w600,
                        size: sizeData.small,
                        color: colorData.fontColor(.6),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.all(aspectRatio * 10),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         colorData.primaryColor(.3),
                    //         colorData.primaryColor(1),
                    //       ],
                    //     ),
                    //   ),
                    //   child: CustomText(
                    //     text: "3",
                    //     color: colorData.secondaryColor(1),
                    //     weight: FontWeight.w700,
                    //   ),
                    // ),
                    CustomText(
                      text: DateFormat.Hm().format(message.time),
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
