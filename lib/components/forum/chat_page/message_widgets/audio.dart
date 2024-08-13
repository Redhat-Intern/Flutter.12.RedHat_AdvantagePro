import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/shimmer_box.dart';

import '../../../../functions/read/course_data.dart';
import '../../../../utilities/theme/color_data.dart';
import '../../../../utilities/theme/size_data.dart';
import '../../../common/icon.dart';
import '../../../common/text.dart';

class ChatMessageAudio extends ConsumerStatefulWidget {
  const ChatMessageAudio(
      {super.key, required this.audioURL, required this.messageID});
  final String audioURL;
  final String messageID;

  @override
  ConsumerState<ChatMessageAudio> createState() => _ChatMessageAudioState();
}

class _ChatMessageAudioState extends ConsumerState<ChatMessageAudio> {
  File? audioFile;
  late PlayerController controller;

  void loadData() async {
    if (widget.audioURL.isNotEmpty) {
      File? audioFileTemp = await CourseService(ref: ref)
          .downloadFile(widget.audioURL, widget.messageID);
      print("****************** ${audioFileTemp!.path}");
      setState(() {
        audioFile = audioFileTemp;
        controller = PlayerController();
        controller.preparePlayer(path: audioFileTemp!.path);
        controller.addListener(() async {
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return audioFile != null
        ? Container(
            height: height * .05,
            width: width * .75,
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorData.primaryColor(.2),
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.playerState == PlayerState.playing) {
                          controller.pausePlayer();
                        } else {
                          controller.startPlayer(finishMode: FinishMode.loop);
                        }
                      },
                      child: CustomIcon(
                        size: sizeData.aspectRatio * 60,
                        icon: controller.playerState == PlayerState.playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: colorData.fontColor(.8),
                      ),
                    ),
                    AudioFileWaveforms(
                      size: Size(width * .6, height * .04),
                      playerController: controller,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(
                        left: width * .02,
                        right: width * .04,
                      ),
                      waveformType: WaveformType.fitWidth,
                      continuousWaveform: true,
                      enableSeekGesture: false,
                      playerWaveStyle: PlayerWaveStyle(
                        scaleFactor: 150,
                        spacing: 5,
                        showSeekLine: false,
                        seekLineColor: colorData.fontColor(.2),
                        waveCap: StrokeCap.round,
                        waveThickness: 2,
                        fixedWaveColor: colorData.fontColor(.2),
                        liveWaveColor: colorData.primaryColor(1),
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CustomText(
                    text: '${controller.maxDuration ~/ 1000}s',
                    size: sizeData.tooSmall,
                  ),
                ),
              ],
            ))
        : ShimmerBox(
            height: height * .05,
            width: width * .75,
          );
  }
}
