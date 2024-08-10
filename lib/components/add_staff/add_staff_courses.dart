import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../common/icon.dart';
import '../common/text.dart';
import 'staff_course_tile.dart';

class AddStaffCourses extends ConsumerStatefulWidget {
  final Function handleCourse;
  const AddStaffCourses({super.key, required this.handleCourse});

  @override
  ConsumerState<AddStaffCourses> createState() => _AddStaffCoursesState();
}

class _AddStaffCoursesState extends ConsumerState<AddStaffCourses> {
  List<Map<File, Map<String, dynamic>>> courses = [];

  bool hasDuplicate({required Map<File, Map<String, dynamic>> course}) {
    for (var element in courses) {
      if (element.values.first["name"] == course.values.first["name"]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: "Courses",
              size: sizeData.medium,
              color: colorData.fontColor(.8),
              weight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: () async {
                var files = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    allowedExtensions: ["pdf", "png", "jpg"],
                    type: FileType.custom,
                    allowCompression: true);
                setState(() {
                  for (var e in files!.files) {
                    File fileData = File(e.path.toString());
                    String name = e.name.toString();
                    String extension = e.extension.toString();
                    int size = e.size;
                    Map<File, Map<String, dynamic>> file = {
                      fileData: {
                        "name": name,
                        "extension": extension,
                        "size": size,
                      }
                    };
                    if (hasDuplicate(course: file)) {
                      courses.add(file);
                      widget.handleCourse(course: file, set: true);
                    }
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: height * 0.008,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorData.secondaryColor(0.4),
                ),
                child: CustomText(
                  text: "Add Course",
                  size: sizeData.regular,
                  color: colorData.primaryColor(1),
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.015,
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            DottedBorder(
              color: colorData.secondaryColor(.4),
              padding: const EdgeInsets.all(4),
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
              dashPattern: const [14, 4, 6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              child: Container(
                height: height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: courses.isEmpty
                    ? Center(
                        child: CustomText(
                          text:
                              "Upload Course certificate as PDF or Image\nby clicking add course\n\nChoose file of size below 5 MB",
                          align: TextAlign.center,
                          size: sizeData.medium,
                          color: colorData.secondaryColor(.5),
                          weight: FontWeight.w600,
                          maxLine: 6,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: courses.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.02,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          File fileData = courses[index].keys.first;
                          String extension =
                              courses[index][fileData]!["extension"];
                          bool isImage =
                              extension == "png" || extension == "jpg";
                          String name = courses[index][fileData]!["name"];
                          int size = courses[index][fileData]!["size"];

                          double kb = size / 1024;
                          double mb = kb / 1024;

                          String fileSize = mb >= 1
                              ? "${mb.toStringAsFixed(2)} MBs"
                              : "${kb.toStringAsFixed(2)} KBs";

                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  OpenFile.open(fileData.path);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.01),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorData.secondaryColor(.5),
                                        colorData.secondaryColor(.1),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height * 0.085,
                                        width: width * 0.2,
                                        margin: EdgeInsets.only(
                                          top: height * 0.005,
                                          bottom: height * 0.005,
                                          left: width * 0.01,
                                          right: width * 0.02,
                                        ),
                                        decoration: isImage
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                image: DecorationImage(
                                                    image: FileImage(fileData),
                                                    fit: BoxFit.cover),
                                              )
                                            : BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    colorData.primaryColor(.3),
                                                    colorData.primaryColor(.1),
                                                  ],
                                                ),
                                              ),
                                        child: isImage
                                            ? const SizedBox()
                                            : Center(
                                                child: CustomText(
                                                  text: extension.toUpperCase(),
                                                  size: sizeData.medium,
                                                  color:
                                                      colorData.fontColor(.8),
                                                  weight: FontWeight.w800,
                                                ),
                                              ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StaffCourseTile(
                                              value: name, field: "Name: "),
                                          StaffCourseTile(
                                              value: fileSize, field: "Size: "),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.handleCourse(
                                          course: courses[index], set: false);
                                      courses.removeAt(index);
                                    });
                                  },
                                  child: CustomIcon(
                                    size: aspectRatio * 45,
                                    icon: Icons.delete_forever_rounded,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
              ),
            ),
            courses.isNotEmpty
                ? Positioned(
                    top: -10,
                    right: -5,
                    child: Container(
                      padding: EdgeInsets.all(aspectRatio * 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorData.primaryColor(1),
                      ),
                      child: CustomText(
                        text: courses.length.toString(),
                        size: sizeData.regular,
                        color: colorData.sideBarTextColor(1),
                        weight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
