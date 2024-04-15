import 'dart:typed_data';

// import 'package:audio_waveform/audio_waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../providers/user_detail_provider.dart';
import '../../../providers/user_select_provider.dart';
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
    this.videoURL,
    this.link,
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
  final String? videoURL;
  final String? link;
  final DateTime time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRole userRole = ref.watch(userRoleProvider)!;
    Map<String, dynamic> userData = ref.watch(userDataProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    bool isSentByMe =
        senderId == (userRole == UserRole.admin ? "admin" : userData["email"]);

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
                            child: Image.asset("assets/images/logo.png"),
                          )
                        : type == MessageType.video
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () async {
                                    // Generate thumbnail from videoURL
                                    Uint8List? thumbnailData =
                                        await VideoThumbnail.thumbnailData(
                                      video: videoURL!,
                                      imageFormat: ImageFormat.JPEG,
                                      maxWidth:
                                          128, // Adjust as per your requirement
                                      quality:
                                          25, //// Adjust as per your requirement
                                    );

                                    // Display the thumbnail as an image
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: thumbnailData != null
                                            ? Image.memory(thumbnailData)
                                            : Text('Thumbnail not available'),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset("assets/images/idea.png"),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: colorData.primaryColor(1)),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: colorData.primaryColor(1),
                                          size: height * 0.05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : type == MessageType.link
                                ? ClipRRect(
                                    child: Text(
                                      link!,
                                      style: TextStyle(
                                          color: colorData.primaryColor(1),
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                : type == MessageType.audio
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle audio message tap event
                                            // You can implement playback functionality or any other action here
                                          },
                                          child: AudioWaveform(
                                            url:
                                                'path_to_audio_file.mp3', // Replace with actual audio file path
                                            width:
                                                300, // Adjust waveform width as needed
                                            height:
                                                50, // Adjust waveform height as needed
                                            backgroundColor: Colors.grey[
                                                300], // Adjust waveform background color as needed
                                            color: Colors
                                                .blue, // Adjust waveform color as needed
                                            progressGradient: LinearGradient(
                                              colors: [
                                                Colors.blue[200]!,
                                                Colors.blue
                                              ], // Adjust progress gradient colors as needed
                                              stops: [0.0, 0.5],
                                            ),
                                            position: Duration(
                                                seconds:
                                                    0), // Adjust initial position if needed
                                            positionColor: const Color.fromARGB(
                                                255,
                                                54,
                                                244,
                                                127), // Adjust position indicator color as needed
                                            zoomLevel:
                                                100, // Adjust zoom level as needed
                                            zoomControllers:
                                                true, // Enable zoom controls
                                          ),
                                        ),
                                      )
                                    : // Handle other message types...

                                    SizedBox()),
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
