import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:redhat_v1/components/forum/chat_page/bubble_painter.dart';
import 'package:redhat_v1/components/forum/triangle_painter.dart';

import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

class ChatMessage extends ConsumerWidget {
  const ChatMessage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.message,
    this.imageURL,
    this.videoURL,
    this.fileURL,
    this.link,
    required this.time,
  });

  final String senderId;
  final String receiverId;
  final MessageType type;
  final String? message;
  final String? imageURL;
  final String? videoURL;
  final String? fileURL;
  final String? link;
  final DateTime time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    bool isSentByMe = senderId == "Hi";

    return Column(
      crossAxisAlignment:
          isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: width * (isSentByMe ? 0.15 : 0),
                right: width * (isSentByMe ? 0 : 0.15),
              ),
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: width * 0.02,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSentByMe ? 10 : 0),
                  topRight: Radius.circular(isSentByMe ? 0 : 10),
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
                color: colorData.secondaryColor(.3),
              ),
              child: type == MessageType.text
                  ? CustomText(
                      text: message!,
                      maxLine: 30,
                    )
                  : type == MessageType.image
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(imageURL!),
                        )
                      : SizedBox(),
            ),
            Positioned(
              top: 0,
              right: isSentByMe ? -width * 0.03 : null,
              left: isSentByMe ? null : -width * 0.035,
              child: RotatedBox(
                quarterTurns: isSentByMe ? 0 : 1,
                child: CustomPaint(
                  size: Size(width * 0.03, height * 0.018),
                  painter: BubblePainter(
                    color: colorData.secondaryColor(.4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -height * 0.02,
              right: isSentByMe ? -5 : null,
              left: isSentByMe ? null : -5,
              child: CustomText(
                text: "5:58 PM",
                color: colorData.fontColor(.6),
                size: sizeData.verySmall,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.0175,
        ),
      ],
    );
  }
}
