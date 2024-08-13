import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../functions/read/course_data.dart';
import '../../../../utilities/theme/color_data.dart';
import '../../../../utilities/theme/size_data.dart';
import '../../../common/icon.dart';
import '../../../common/shimmer_box.dart';

class ChatMessageVideo extends ConsumerStatefulWidget {
  const ChatMessageVideo({
    super.key,
    required this.fileURL,
    required this.messageID,
  });
  final String fileURL;
  final String messageID;

  @override
  ConsumerState<ChatMessageVideo> createState() => _ChatMessageVideoState();
}

class _ChatMessageVideoState extends ConsumerState<ChatMessageVideo> {
  VideoPlayerController? controller;

  void loadData() async {
    if (widget.fileURL.isNotEmpty) {
      File? fileTemp = await CourseService(ref: ref)
          .downloadFile(widget.fileURL, widget.messageID);
      setState(() {
        controller = VideoPlayerController.file(fileTemp!);
        controller!.initialize();
        controller!.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return controller != null
        ? Container(
            height: height * .25,
            width: width * .8,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorData.primaryColor(.2),
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: VideoPlayer(controller!),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (controller!.value.isPlaying) {
                        controller!.pause();
                      } else {
                        controller!.play();
                      }
                    },
                    child: CustomIcon(
                      icon: controller!.value.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      color: colorData.fontColor(1),
                      size: sizeData.aspectRatio * 100,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ShimmerBox(
            height: height * .25,
            width: width * .8,
          );
  }
}
