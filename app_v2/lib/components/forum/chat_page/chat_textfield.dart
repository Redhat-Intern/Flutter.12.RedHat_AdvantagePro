import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../functions/update/update_chat_message.dart';
import '../../../providers/chat_scroll_provider.dart';
import '../../../utilities/console_logger.dart';
import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';
import 'chat_filepreview.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({
    super.key,
    required this.index,
  });
  final int index;

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  TextEditingController controller = TextEditingController();
  MapEntry<File, Map<String, dynamic>>? pickedFile;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void clearFileData() {
    setState(() {
      pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pickedFile != null)
          PickedFileViewer(
            pickedFile: pickedFile!,
            clear: clearFileData,
          ),
        Container(
          margin: EdgeInsets.only(bottom: height * 0.02, top: height * 0.01),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  height: height *
                      (controller.text.trim().length < 28
                          ? 0.05
                          : controller.text.trim().length < 60
                              ? .1
                              : .15),
                  width: width,
                  padding: EdgeInsets.only(left: width * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorData.secondaryColor(.3),
                  ),
                  child: TextField(
                    controller: controller,
                    onTap: () {
                      ref.read(chatScrollProvider.notifier).jump();
                    },
                    readOnly: pickedFile != null,
                    maxLines: 100,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: aspectRatio * 33,
                      color: colorData.fontColor(.8),
                    ),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: pickedFile != null
                          ? "Tap to send the ${fileCategories[".${pickedFile!.value["extension"]}"]} 👉"
                          : "Type a message",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.medium,
                        color: colorData.fontColor(pickedFile != null ? 1 : .5),
                      ),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (controller.text.trim().isNotEmpty) {
                            uploadChat(
                              text: controller.text.trim(),
                              ref: ref,
                              index: widget.index,
                            );
                            controller.clear();
                          } else if (pickedFile != null) {
                            String category = fileCategories[
                                '.${pickedFile!.value["extension"]}']!;
                            String metadata = category == 'document'
                                ? pickedFile!.value["extension"]
                                : category;
                            uploadChat(
                              ref: ref,
                              index: widget.index,
                              file: pickedFile!.key,
                              metadata: metadata,
                              fileExtension: pickedFile!.value["extension"],
                            );
                            setState(() {
                              pickedFile = null;
                            });
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: CustomIcon(
                          icon: Icons.send_rounded,
                          color: colorData.fontColor(.8),
                          size: aspectRatio * 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    pickedFile = null;
                  });
                  var files = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.any,
                      allowCompression: true);
                  if (files != null) {
                    PlatformFile e = files.files.first;
                    String extension = e.extension.toString();
                    if (fileCategories.keys.contains('.$extension')) {
                      File fileData = File(e.path.toString());
                      String name = e.name.toString();
                      int size = e.size;
                      MapEntry<File, Map<String, dynamic>> file =
                          MapEntry(fileData, {
                        "name": name,
                        "extension": extension,
                        "size": size,
                        "type": fileCategories['.$extension']
                      });
                      setState(() {
                        pickedFile = file;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Center(
                        child: Text("File type not supported"),
                      )));
                      ConsoleLogger.error("File type not supported $extension",
                         );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(aspectRatio * 12),
                  margin: EdgeInsets.only(left: width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorData.secondaryColor(.4),
                  ),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: colorData.fontColor(.7),
                    size: aspectRatio * 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
