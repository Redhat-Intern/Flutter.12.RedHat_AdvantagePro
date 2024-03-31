import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redhat_v1/components/common/page_header.dart';
import 'package:redhat_v1/components/common/text.dart';
import 'package:redhat_v1/functions/create/create_certficate.dart';

import '../components/add_certificate/course_files.dart';
import '../components/common/shimmer_box.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class CourseUpdate extends ConsumerStatefulWidget {
  const CourseUpdate(
      {super.key,
      required this.dayIndex,
      required this.batchName,
      required this.certificateName});
  final String dayIndex;
  final String batchName;
  final String certificateName;

  @override
  ConsumerState<CourseUpdate> createState() => CourseUpdateState();
}

class CourseUpdateState extends ConsumerState<CourseUpdate> {
  bool onceSet = false;
  bool isFirst = false;
  TextEditingController titleCtr = TextEditingController();
  TextEditingController topicCtr = TextEditingController();

  Map<File, Map<String, dynamic>> courseFiles = {};
  Map<String, dynamic> loadedFiles = {};

  void handleFile(
      {required MapEntry<File, Map<String, dynamic>> file, required bool set}) {
    setState(() {
      if (set) {
        if (!courseFiles.containsKey(file.key)) {
          courseFiles.addEntries([file]);
        }
      } else {
        courseFiles.remove(file.key);
      }
    });
  }

  Future<File?> downloadFile(String path, String name) async {
    try {
      final response = await Dio()
          .get(path, options: Options(responseType: ResponseType.bytes));

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$name';
      final file = await File(filePath).writeAsBytes(response.data);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateCourseData(
      {required Map<String, dynamic> dayCourseData}) async {
    if (onceSet) {
      titleCtr.text = dayCourseData["title"] ?? "";
      topicCtr.text = dayCourseData["topics"] ?? "";
      Map<File, Map<String, dynamic>> fileMap = {};
      if (dayCourseData["files"] != null) {
        for (MapEntry<String, Map<dynamic, dynamic>> e
            in Map<String, dynamic>.from(dayCourseData["files"]).entries.map(
                (MapEntry<String, dynamic> e) =>
                    MapEntry(e.key, Map.from(e.value)))) {
          File? file = await downloadFile(e.key, e.value["name"]);
          if (file != null) {
            fileMap.addAll({file: Map<String, dynamic>.from(e.value)});
          }
        }
        setState(() {
          courseFiles = fileMap;
          onceSet = false;
        });
      }
      onceSet = false;
    }
  }

  void updateChanges() async {
    Reference ref = FirebaseStorage.instance.ref();

    Reference dayFolderRef = ref.child(
        "certificate/${widget.certificateName}/courseData/${widget.dayIndex}/");
    ListResult result = await dayFolderRef.listAll();

    for (var element in result.items) {
      await element.delete();
    }

    Map<String, Map<String, dynamic>> uploadedFilesData = await uploadFiles(
        files: courseFiles,
        path:
            "certificate/${widget.certificateName}/courseData/${widget.dayIndex}/",
        ref: ref);

    print("ploaded files");

    DocumentReference docRef = FirebaseFirestore.instance
        .collection("certificates")
        .doc(widget.certificateName)
        .collection("instances")
        .doc(widget.batchName);

    docRef.set({
      "courseContent": {
        widget.dayIndex: {
          "files": FieldValue.delete(),
        }
      }
    }, SetOptions(merge: true));

    docRef.set({
      "courseContent": {
        widget.dayIndex: {
          "title": titleCtr.text,
          "topics": topicCtr.text,
          "files": uploadedFilesData,
        }
      }
    }, SetOptions(merge: true));

    print("corrected");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text("Course Data updated successfuly"),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    onceSet = true;
    isFirst = true;
  }

  @override
  void dispose() {
    titleCtr.dispose();
    topicCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("certificates")
                  .doc(widget.certificateName)
                  .collection("instances")
                  .doc(widget.batchName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    isFirst) {
                  isFirst = false;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  Map<String, dynamic>? dayCourseData = snapshot.data!
                              .data()!["courseContent"][widget.dayIndex] !=
                          null
                      ? Map<String, dynamic>.from(snapshot.data!
                          .data()!["courseContent"][widget.dayIndex])
                      : {};
                  if (dayCourseData.isNotEmpty) {
                    updateCourseData(dayCourseData: dayCourseData);
                  } else {
                    onceSet = false;
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(tittle: "course edit"),
                    SizedBox(height: height * 0.03),
                    CustomText(
                        text: "Title of the day:",
                        size: sizeData.medium,
                        color: colorData.fontColor(.7),
                        weight: FontWeight.w800),
                    SizedBox(height: height * 0.01),
                    CourseEditTextField(
                      controller: titleCtr,
                      hintText: "Enter the title ",
                      maxLines: 2,
                    ),
                    SizedBox(height: height * .02),
                    CustomText(
                        text: "Topics to be covered:",
                        size: sizeData.medium,
                        color: colorData.fontColor(.7),
                        weight: FontWeight.w800),
                    SizedBox(height: height * 0.01),
                    CourseEditTextField(
                      controller: topicCtr,
                      hintText: "Enter the topics (seperated by commas) ",
                      maxLines: 3,
                    ),
                    SizedBox(height: height * .02),
                    CustomText(
                        text: "Reference documents:",
                        size: sizeData.medium,
                        color: colorData.fontColor(.7),
                        weight: FontWeight.w800),
                    SizedBox(height: height * 0.01),
                    onceSet
                        ? Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Column(
                              children: List.generate(
                                2,
                                (index) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.01,
                                  ),
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.015),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorData.backgroundColor(.5),
                                        colorData.backgroundColor(.1),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      ShimmerBox(
                                        height: aspectRatio * 120,
                                        width: aspectRatio * 120,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShimmerBox(
                                            width: width * 0.5,
                                            height: height * 0.02,
                                          ),
                                          SizedBox(height: height * 0.015),
                                          ShimmerBox(
                                            width: width * 0.2,
                                            height: height * 0.02,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : CourseFilePicker(
                            content: courseFiles,
                            handleFile: handleFile,
                            containerHeight: height * .35,
                          ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => updateChanges(),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.015,
                              horizontal: width * 0.08),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                colorData.primaryColor(.5),
                                colorData.primaryColor(1),
                              ],
                            ),
                          ),
                          child: CustomText(
                              text: "SAVE CHNAGES",
                              size: sizeData.subHeader,
                              weight: FontWeight.w800,
                              color: colorData.sideBarTextColor(1)),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class CourseEditTextField extends ConsumerWidget {
  const CourseEditTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;

    return Container(
      padding: EdgeInsets.only(left: width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [colorData.secondaryColor(.2), colorData.secondaryColor(.4)],
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: sizeData.regular,
          color: colorData.fontColor(.8),
          height: 1.3,
        ),
        cursorColor: colorData.primaryColor(1),
        cursorWidth: 2,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: sizeData.regular,
            color: colorData.fontColor(.5),
            height: 1.3,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
