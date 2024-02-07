import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/static_data.dart';
import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../common/text.dart';

class CertificateImagePicker extends ConsumerStatefulWidget {
  final From from;
  final Function setter;
  final String imageURL;
  const CertificateImagePicker({
    super.key,
    required this.from,
    required this.imageURL,
    required this.setter,
  });

  @override
  ConsumerState<CertificateImagePicker> createState() =>
      _CertificateImagePickerState();
}

class _CertificateImagePickerState
    extends ConsumerState<CertificateImagePicker> {
  File? image;
  String? imageName;

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
                    image = File(file.files.first.path!);
                    imageName = file.files.first.name;
                    widget.setter(image, imageName);
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
                child: image == null
                    ? widget.from == From.detail
                        ? Image.network(
                            widget.imageURL,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: CustomText(
                              text: "Image",
                              size: sizeData.regular,
                              color: colorData.primaryColor(.6),
                              weight: FontWeight.w600,
                            ),
                          )
                    : Image.file(
                        image!,
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
          child: SizedBox(
            width: height * 0.1,
            child: CustomText(
              text: imageName == null ? "Select Image" : imageName!,
              align: TextAlign.center,
              size: sizeData.verySmall,
              color: colorData.fontColor(.5),
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
