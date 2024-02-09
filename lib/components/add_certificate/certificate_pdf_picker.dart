import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';

class CertificatePDF extends ConsumerStatefulWidget {
  final Function setter;
  const CertificatePDF({
    super.key,
    required this.setter,
  });

  @override
  ConsumerState<CertificatePDF> createState() => _CertificatePDFState();
}

class _CertificatePDFState extends ConsumerState<CertificatePDF> {
  String? imageName;

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
        CustomText(
          text: "Upload PDF",
          size: sizeData.medium,
          color: colorData.fontColor(.8),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * .01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Select the PDF of complete course content: ",
                    maxLine: 2,
                    size: sizeData.small,
                    color: colorData.fontColor(.6),
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  CustomText(
                    text: imageName ?? "",
                    size: sizeData.small,
                    color: colorData.primaryColor(.4),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                FilePickerResult? file = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['pdf', "ppt", "pptx"],
                    type: FileType.custom,
                    allowMultiple: false);
                if (file == null) {
                  return;
                } else {
                  setState(() {
                    File pdf = File(file.files.first.path!);
                    imageName = file.files.first.name;
                    widget.setter(pdf, imageName);
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: width * 0.02),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.015,
                  vertical: height * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorData.secondaryColor(.4),
                ),
                child: Row(
                  children: [
                    CustomIcon(
                      icon: Icons.upload_file_outlined,
                      size: aspectRatio * 40,
                      color: colorData.primaryColor(1),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    CustomText(
                      text: 'PDF',
                      size: sizeData.regular,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w800,
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
