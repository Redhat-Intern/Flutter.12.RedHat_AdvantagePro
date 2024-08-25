import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../functions/read/course_data.dart';
import '../../../../utilities/theme/size_data.dart';
import '../../../common/shimmer_box.dart';
import '../../../home/student/file_tile.dart';

class ChatMessageFile extends ConsumerStatefulWidget {
  const ChatMessageFile(
      {super.key,
      required this.fileURL,
      required this.messageID,
      required this.metadata});
  final String fileURL;
  final String messageID;
  final String metadata;

  @override
  ConsumerState<ChatMessageFile> createState() => _ChatMessageFileState();
}

class _ChatMessageFileState extends ConsumerState<ChatMessageFile> {
  File? file;

  void loadData() async {
    if (widget.fileURL.isNotEmpty) {
      File? fileTemp = await ref.read(courseServiceProvider)
          .downloadFile(widget.fileURL, widget.messageID);
      setState(() {
        file = fileTemp;
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

    double aspectRatio = sizeData.aspectRatio;

    return file != null
        ? FileTile(
            fileData: file!,
            isImage: false,
            extension: widget.metadata,
            needBottomPadding: false,
            name: '')
        : ShimmerBox(
            height: aspectRatio * 200,
            width: aspectRatio * 200,
          );
  }
}
