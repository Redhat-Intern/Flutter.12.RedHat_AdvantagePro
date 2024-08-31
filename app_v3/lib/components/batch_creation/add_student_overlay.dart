import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';

class AddStudentOverlay extends ConsumerStatefulWidget {
  final Function setter;
  const AddStudentOverlay({super.key, required this.setter});

  @override
  ConsumerState<AddStudentOverlay> createState() => _AddStudentOverlayState();
}

class _AddStudentOverlayState extends ConsumerState<AddStudentOverlay> {
  Map<File, String> excelData = {};

  Future<String> generateExcelFile() async {
    List<List<String>> body = [];
    List<String> header = [
      'RegistrationID'
          'Name',
      'Email',
      'Phone No',
      'Occupation',
      'Occupation detail',
    ];
    body.add(header);
    body.add([
      'STU001',
      'John Doe',
      'john.doe@email.com',
      '1234567890',
      'college',
      'sri sairam college',
    ]);

    // exportCSV.myCSV(header, body);
    String csv = const ListToCsvConverter().convert(body);

    final directoryPath = await getExternalStorageDirectory();
    final path = "${directoryPath!.path}/sample.csv";
    final File file = File(path);
    await file.writeAsString(csv);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    List<String> columnData = [
      "RegistrationID",
      "Name",
      "Email",
      "PhoneNo",
      "Occupation (college/professional)",
      "Occupation detail"
    ];
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return AlertDialog(
      backgroundColor: colorData.backgroundColor(1),
      elevation: 0,
      scrollable: true,
      title: CustomText(
        text: "Execl Sheet Format",
        size: sizeData.medium,
        color: colorData.fontColor(.8),
        weight: FontWeight.w600,
      ),
      titlePadding: EdgeInsets.only(
        left: width * .22,
        top: height * .03,
        bottom: height * 0.02,
      ),
      actionsOverflowButtonSpacing: height * 0.02,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        GestureDetector(
          onTap: () async {
            String filePath = await generateExcelFile();
            OpenFile.open(filePath);
          },
          child: CustomText(
            text: "Click to Download the sample Excel sheet",
            size: sizeData.regular,
            color: colorData.primaryColor(.6),
            weight: FontWeight.w600,
            maxLine: 2,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: "Excel Sheet Columns",
            size: sizeData.regular,
            color: colorData.fontColor(.8),
            weight: FontWeight.w600,
          ),
        ),
        Container(
          height: height * 0.045,
          width: width,
          padding: EdgeInsets.symmetric(
              vertical: height * 0.005, horizontal: width * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colorData.primaryColor(.1),
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                colorData.primaryColor(.1),
              ],
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: columnData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: width * 0.03),
                padding:
                    EdgeInsets.only(right: width * 0.03, top: height * 0.006),
                decoration: BoxDecoration(
                  border: index == columnData.length - 1
                      ? const Border()
                      : Border(
                          right: BorderSide(
                            color: colorData.fontColor(.2),
                            width: 3,
                          ),
                        ),
                ),
                child: CustomText(
                  text: columnData[index],
                  size: sizeData.regular,
                  color: colorData.fontColor(.6),
                  weight: FontWeight.w800,
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Upload Excel Sheet: ",
                    size: sizeData.regular,
                    color: colorData.fontColor(.6),
                  ),
                  excelData.isNotEmpty
                      ? SizedBox(
                          height: height * 0.001,
                        )
                      : const SizedBox(),
                  excelData.isNotEmpty
                      ? CustomText(
                          text: excelData.values.first,
                          size: sizeData.regular,
                          color: colorData.primaryColor(1),
                          weight: FontWeight.w800,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () async {
                FilePickerResult? excelSheetResult =
                    await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  allowedExtensions: ["csv", "xlsx", "xls", "gsheet"],
                  type: FileType.custom,
                  allowCompression: true,
                );
                if (excelSheetResult != null) {
                  PlatformFile excelSheet = excelSheetResult.files.first;
                  File fileData = File(excelSheet.path.toString());
                  String name = excelSheet.name.toString();
                  Map<File, String> file = {fileData: name};
                  setState(() {
                    excelData = file;
                    widget.setter(file);
                  });
                }
                Navigator.pop(context);
              },
              child: Container(
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
                      text: 'EXCEL',
                      size: sizeData.regular,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w800,
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
