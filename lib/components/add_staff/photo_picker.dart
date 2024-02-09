import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class PhotoPicker extends ConsumerStatefulWidget {
  final From from;
  final Function setter;
  final String photoURL;
  const PhotoPicker({
    super.key,
    required this.setter,
    required this.from,
    this.photoURL = "",
  });

  @override
  ConsumerState<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends ConsumerState<PhotoPicker> {
  File? photo;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: DottedBorder(
            color: colorData.primaryColor(1),
            padding: const EdgeInsets.all(4),
            strokeCap: StrokeCap.round,
            strokeWidth: 2,
            dashPattern: const [10, 4, 6, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            child: GestureDetector(
              onTap: () async {
                FilePickerResult? file = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['png', 'jpg'],
                    type: FileType.custom,
                    allowMultiple: false);
                if (file == null) {
                  return;
                } else {
                  setState(() {
                    photo = File(file.files.first.path!);
                    String photoName = file.files.first.name;
                    widget.setter(photo, photoName);
                  });
                }
              },
              child: Container(
                width: height * 0.1,
                height: height * 0.1,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: photo == null
                    ? widget.from == From.detail
                        ? Image.network(
                            widget.photoURL,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: CustomText(
                              text: "PHOTO",
                              size: sizeData.regular,
                              color: colorData.primaryColor(.6),
                              weight: FontWeight.w600,
                            ),
                          )
                    : Image.file(
                        photo!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Align(
          alignment: Alignment.center,
          child: CustomText(
            text: widget.from == From.detail
                ? "Tap to edit profile photo"
                : "Tap to add profile photo",
            size: sizeData.small,
            color: colorData.fontColor(.5),
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
