import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:redhat_v1/components/common/shimmer_box.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';

class CertificatePDF extends ConsumerStatefulWidget {
  final Function? setter;
  final From from;
  final File? file;

  const CertificatePDF({
    super.key,
    this.setter,
    required this.from,
    this.file,
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
          text: widget.from == From.detail ? "Course PDF" : "Upload PDF",
          size: sizeData.medium,
          color: colorData.fontColor(.8),
          weight: FontWeight.w800,
        ),
        SizedBox(
          height: height * .01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.from == From.detail
                        ? "Tap to download the PDF file"
                        : "Select the PDF of complete course content: ",
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
            (widget.from == From.detail && widget.file!.path.isEmpty)
                ? ShimmerBox(height: height * 0.03, width: width * .17)
                : GestureDetector(
                    onTap: () async {
                      if (widget.from == From.detail) {
                        OpenFile.open(widget.file!.path);
                      } else {
                        FilePickerResult? file = await FilePicker.platform
                            .pickFiles(
                                allowedExtensions: ['pdf', "ppt", "pptx"],
                                type: FileType.custom,
                                allowMultiple: false);
                        if (file == null) {
                          return;
                        } else {
                          setState(() {
                            File pdf = File(file.files.first.path!);
                            imageName = file.files.first.name;
                            widget.setter!(pdf, imageName);
                          });
                        }
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
