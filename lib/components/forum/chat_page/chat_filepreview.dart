import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:redhat_v1/components/home/student/file_tile.dart';
import 'package:video_player/video_player.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';

class PickedFileViewer extends ConsumerStatefulWidget {
  const PickedFileViewer({
    super.key,
    required this.pickedFile,
    required this.clear,
  });
  final MapEntry<File, Map<String, dynamic>> pickedFile;
  final Function clear;

  @override
  ConsumerState<PickedFileViewer> createState() => PickedFileViewerState();
}

class PickedFileViewerState extends ConsumerState<PickedFileViewer> {
  late PlayerController controller;
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    if (widget.pickedFile.value["type"] == 'audio') {
      controller = PlayerController();
      controller.preparePlayer(path: widget.pickedFile.key.path);
      controller.addListener(() async {
        if (mounted) {
          setState(() {});
        }
      });
    } else if (widget.pickedFile.value["type"] == 'video') {
      videoPlayerController = VideoPlayerController.file(widget.pickedFile.key);
      videoPlayerController.initialize();
      videoPlayerController.addListener(() async {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.pickedFile.value["type"] == 'audio') {
      controller.dispose();
    } else if (widget.pickedFile.value["type"] == 'video') {
      videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double height = sizeData.height;
    double width = sizeData.width;

    Widget deleteButton = GestureDetector(
      onTap: () => widget.clear(),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: colorData.backgroundColor(1),
            border: Border.all(color: colorData.fontColor(1), width: 1.5)),
        child: CustomIcon(
          icon: Icons.clear_rounded,
          color: Colors.red,
          size: sizeData.aspectRatio * 40,
        ),
      ),
    );

    if (widget.pickedFile.value["type"] == 'image') {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width * 0.02, right: width * 0.02, top: height * 0.04),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.primaryColor(.2),
              border: Border.all(
                color: colorData.primaryColor(.4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            height: height * .25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                widget.pickedFile.key,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            top: height * 0.05,
            right: width * 0.04,
            child: deleteButton,
          ),
        ],
      );
    } else if (widget.pickedFile.value["type"] == 'audio') {
      return Center(
        child: Container(
            height: height * .05,
            margin: EdgeInsets.only(
                left: width * 0.04, right: width * 0.04, top: height * 0.04),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorData.fontColor(.2),
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
                        color: colorData.fontColor(1),
                      ),
                    ),
                    AudioFileWaveforms(
                      size: Size(width * .625, height * .04),
                      playerController: controller,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(
                        left: width * .02,
                        right: width * .04,
                      ),
                      waveformType: WaveformType.long,
                      continuousWaveform: true,
                      enableSeekGesture: false,
                      playerWaveStyle: PlayerWaveStyle(
                        scaleFactor: 150,
                        spacing: 5,
                        seekLineColor: colorData.fontColor(.2),
                        waveCap: StrokeCap.round,
                        waveThickness: 2,
                        fixedWaveColor: colorData.primaryColor(.4),
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
                Positioned(
                  right: 0,
                  top: 0,
                  child: deleteButton,
                )
              ],
            )),
      );
    } else if (widget.pickedFile.value["type"] == "video") {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width * 0.02, right: width * 0.02, top: height * 0.04),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorData.primaryColor(.2),
                width: 4,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            height: height * .25,
            width: width * .8,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: VideoPlayer(videoPlayerController),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (videoPlayerController.value.isPlaying) {
                        videoPlayerController.pause();
                      } else {
                        videoPlayerController.play();
                      }
                    },
                    child: CustomIcon(
                      icon: videoPlayerController.value.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      color: colorData.fontColor(1),
                      size: sizeData.aspectRatio * 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: height * 0.05,
            right: width * 0.04,
            child: deleteButton,
          )
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width * 0.04, right: width * 0.04, top: height * 0.04),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorData.primaryColor(.2),
                width: 3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: FileTile(
              fileData: widget.pickedFile.key,
              isImage: false,
              extension: widget.pickedFile.value["extension"],
              name: widget.pickedFile.value["name"],
              needBottomPadding: false,
            ),
          ),
          Positioned(
            top: height * 0.045,
            right: width * 0.05,
            child: deleteButton,
          )
        ],
      );
    }
  }
}
