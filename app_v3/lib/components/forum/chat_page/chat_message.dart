import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/user.dart';
import '../../../providers/user_detail_provider.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/network_image.dart';
import '../../common/text.dart';
import 'bubble_painter.dart';
import 'message_widgets/audio.dart';
import 'message_widgets/document.dart';
import 'message_widgets/video.dart';

class ChatTile extends ConsumerStatefulWidget {
  const ChatTile({
    super.key,
    required this.name,
    required this.senderId,
    required this.previousSenderId,
    required this.senderImage,
    required this.receiverId,
    required this.type,
    required this.isGroup,
    this.message,
    this.imageURL,
    this.fileURL,
    required this.time,
    this.specType,
    required this.deleteChat,
  });

  final String previousSenderId;
  final String senderId;
  final String senderImage;
  final String name;
  final String receiverId;
  final bool isGroup;
  final MessageType type;
  final String? message;
  final String? imageURL;
  final String? fileURL;
  final DateTime time;
  final String? specType;
  final Function deleteChat;

  @override
  ConsumerState<ChatTile> createState() => ChatTileState();
}

class ChatTileState extends ConsumerState<ChatTile> {
  bool showDelete = false;

  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider).key;
    UserRole userRole = userData.userRole!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    if (showDelete) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showDelete = false;
          });
        }
      });
    }

    bool isSentByMe = widget.senderId ==
        (userRole == UserRole.superAdmin ? "admin" : userData.email);
    final List<TextSpan> textSpans = [];

    if (widget.message != null) {
      final RegExp linkRegex = RegExp(
        r'((https?:\/\/|www\.)[^\s]+)|([^\s]+\.(com|org|net|io|in|co|gov|edu|me))',
        caseSensitive: false,
      );

      final RegExp boldRegex = RegExp(r'\*(.*?)\*');
      String remainingText = widget.message!;

      while (remainingText.isNotEmpty) {
        final linkMatch = linkRegex.firstMatch(remainingText);
        final boldMatch = boldRegex.firstMatch(remainingText);

        if (linkMatch == null && boldMatch == null) {
          // No more matches, add the remaining text as is
          textSpans.add(TextSpan(
            text: remainingText,
            style: TextStyle(
              fontSize: sizeData.medium,
              color: colorData.fontColor(.8),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ));
          break;
        }

        // Determine the first match (link or bold) in the remaining text
        final firstMatch = [linkMatch, boldMatch]
            .where((match) => match != null)
            .reduce((a, b) => a!.start < b!.start ? a : b)!;

        if (firstMatch.start > 0) {
          // Add text before the match
          textSpans.add(TextSpan(
            text: remainingText.substring(0, firstMatch.start),
            style: TextStyle(
              fontSize: sizeData.medium,
              color: colorData.fontColor(.8),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ));
        }

        if (linkRegex.hasMatch(firstMatch[0]!)) {
          // Handle links
          final String url = firstMatch[0]!;
          textSpans.add(
            TextSpan(
              text: url,
              style: TextStyle(
                fontSize: sizeData.subHeader,
                color: colorData.primaryColor(1),
                fontWeight: FontWeight.w900,
                height: 1.5,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri uri =
                      Uri.parse(url.startsWith('http') ? url : 'http://$url');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
            ),
          );
        } else if (boldRegex.hasMatch(firstMatch[0]!)) {
          // Handle bold text
          final String boldText = firstMatch[1]!; // The text between * *
          textSpans.add(
            TextSpan(
              text: boldText,
              style: TextStyle(
                fontSize: sizeData.subHeader,
                color: colorData.fontColor(1),
                fontWeight: FontWeight.w900,
                fontFamily: FontFamilyENUM.IstokWeb.name,
                height: 1.5,
              ),
            ),
          );
        }

        // Update the remaining text
        remainingText = remainingText.substring(firstMatch.end);
      }
    }

    return GestureDetector(
      onLongPress: () {},
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: height *
                  ((widget.isGroup &&
                          widget.previousSenderId != widget.senderId)
                      ? 0.05
                      : 0.01)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              widget.isGroup && widget.previousSenderId != widget.senderId
                  ? Positioned(
                      top: -height * 0.02,
                      left: isSentByMe ? null : aspectRatio * 30,
                      right: isSentByMe ? aspectRatio * 30 : null,
                      child: CustomText(
                        text: widget.name.toUpperCase(),
                        size: sizeData.verySmall,
                        weight: FontWeight.w700,
                      ),
                    )
                  : const SizedBox(),
              widget.isGroup && widget.previousSenderId != widget.senderId
                  ? Positioned(
                      top: -aspectRatio * 65,
                      left: isSentByMe ? null : -aspectRatio * 40,
                      right: isSentByMe ? -aspectRatio * 40 : null,
                      child: CustomNetworkImage(
                        size: aspectRatio * 60,
                        radius: 4,
                        url: widget.senderImage,
                        padding: 1.25,
                      ),
                    )
                  : const SizedBox(),
              GestureDetector(
                onLongPress: () {
                  if (isSentByMe || userData.userRole == UserRole.superAdmin) {
                    setState(() {
                      showDelete = true;
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: width * (isSentByMe ? 0.05 : 0),
                    right: width * (isSentByMe ? 0 : 0.05),
                  ),
                  padding: EdgeInsets.only(
                    left: aspectRatio * 20,
                    right: aspectRatio * 10,
                    top: aspectRatio * 15,
                    bottom: aspectRatio * 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((isSentByMe ||
                              widget.previousSenderId == widget.senderId)
                          ? 8
                          : 0),
                      topRight: Radius.circular(isSentByMe &&
                              widget.previousSenderId != widget.senderId
                          ? 0
                          : 8),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                    color: isSentByMe
                        ? colorData.secondaryColor(.3)
                        : colorData.primaryColor(.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        width:
                            widget.message != null && widget.message!.length < 5
                                ? width * .15
                                : null,
                        child: widget.type == MessageType.text
                            ? RichText(
                                text: TextSpan(children: textSpans),
                              )
                            : widget.type == MessageType.image
                                ? CustomNetworkImage(
                                    size: width * .4,
                                    radius: 10,
                                    url: widget.imageURL,
                                    height: height * .18,
                                    fit: BoxFit.fitHeight,
                                  )
                                : widget.type == MessageType.audio
                                    ? ChatMessageAudio(
                                        audioURL: widget.fileURL!,
                                        messageID:
                                            "${widget.senderId}${widget.time.millisecond}.mp3",
                                      )
                                    : widget.type == MessageType.video
                                        ? ChatMessageVideo(
                                            fileURL: widget.fileURL!,
                                            messageID:
                                                "${widget.senderId}${widget.time.millisecond}.mp4",
                                          )
                                        : ChatMessageFile(
                                            fileURL: widget.fileURL!,
                                            messageID:
                                                "${widget.senderId}${widget.time.millisecond}.${widget.specType}",
                                            metadata: widget.specType!,
                                          ),
                      ),
                      CustomText(
                        text: DateFormat('hh:mm a').format(widget.time),
                        color: colorData.fontColor(.6),
                        size: sizeData.tooSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.previousSenderId != widget.senderId)
                Positioned(
                  top: 0,
                  right: isSentByMe ? -width * 0.03 : null,
                  left: isSentByMe ? null : -width * 0.04,
                  child: RotatedBox(
                    quarterTurns: isSentByMe ? 0 : 1,
                    child: CustomPaint(
                      size: Size(width * 0.03, height * 0.018),
                      painter: BubblePainter(
                        color: isSentByMe
                            ? colorData.secondaryColor(.3)
                            : colorData.primaryColor(.1),
                      ),
                    ),
                  ),
                ),
              if (showDelete)
                Positioned(
                  left: isSentByMe ? -10 : null,
                  right: isSentByMe ? null : -10,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      widget.deleteChat();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: Icon(
                        Icons.delete,
                        size: aspectRatio * 45,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
