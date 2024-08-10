import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/user.dart';
import '../../../providers/user_detail_provider.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import 'bubble_painter.dart';

class ChatTile extends ConsumerWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.isGroup,
    this.message,
    this.imageURL,
    this.fileURL,
    required this.time,
  });

  final String senderId;
  final String name;
  final String receiverId;
  final bool isGroup;
  final MessageType type;
  final String? message;
  final String? imageURL;
  final String? fileURL;
  final DateTime time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userData = ref.watch(userDataProvider).key;
    UserRole userRole = userData.userRole!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    bool isSentByMe =
        senderId == (userRole == UserRole.admin ? "admin" : userData.email);

    return Column(
      crossAxisAlignment:
          isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * (isGroup ? 0.0225 : 0.015)),
        Stack(
          clipBehavior: Clip.none,
          children: [
            isGroup
                ? Positioned(
                    top: -height * 0.02,
                    left: isSentByMe ? null : 0,
                    right: isSentByMe ? 0 : null,
                    child: CustomText(
                      text: name.toUpperCase(),
                      size: sizeData.verySmall,
                      weight: FontWeight.w700,
                    ),
                  )
                : const SizedBox(),
            Container(
              margin: EdgeInsets.only(
                left: width * (isSentByMe ? 0.05 : 0),
                right: width * (isSentByMe ? 0 : 0.05),
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
                color: isSentByMe
                    ? colorData.secondaryColor(.3)
                    : colorData.primaryColor(.1),
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
                      : const SizedBox(),
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
                    color: isSentByMe
                        ? colorData.secondaryColor(.4)
                        : colorData.primaryColor(.1),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -height * 0.02,
              right: isSentByMe ? -5 : null,
              left: isSentByMe ? null : -5,
              child: CustomText(
                text: DateFormat('hh:mm a').format(time),
                color: colorData.fontColor(.8),
                size: sizeData.verySmall,
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * (isGroup ? 0.0225 : 0.015),
        ),
      ],
    );
  }
}
