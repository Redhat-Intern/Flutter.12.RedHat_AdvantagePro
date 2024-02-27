import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redhat_v1/components/home/student/course_content.dart';

import '../../components/home/student/course_files.dart';
import '../../utilities/static_data.dart';
import '../../functions/create/add_staff.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/add_staff/add_staff_certificate.dart';
import '../../components/add_staff/custom_input_field.dart';
import '../../components/add_staff/photo_picker.dart';
import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

class StaffDetail extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String experience;
  final List<dynamic> certificatesURL;
  final String photoURL;

  const StaffDetail({
    super.key,
    required this.photoURL,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.experience,
    required this.certificatesURL,
  });

  @override
  ConsumerState<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends ConsumerState<StaffDetail> {
  Map<File, String> photo = {};
  TextEditingController nameController = TextEditingController(text: "...");
  TextEditingController emailController = TextEditingController(text: "...");
  TextEditingController phoneNoController = TextEditingController(text: "");
  TextEditingController experienceController = TextEditingController(text: "");
  List<Map<File, Map<String, dynamic>>> certificates = [];

  Map<File, Map<String, dynamic>> dynamicCourseFiles = {};
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

  // void updateCourseFiles() {
  //   dynamicCourseFiles.clear();
  //   widget.certificatesURL.forEach((key, value) async {
  //     File? file = await downloadFile(key, value["name"]);
  //     if (file != null) {
  //       setState(() {
  //         dynamicCourseFiles.addAll({file: value});
  //       });
  //     }
  //   });
  // }

  // @override
  // void didUpdateWidget(CourseFiles oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.courseFiles.keys.first != oldWidget.courseFiles.keys.first) {
  //     updateCourseFiles();
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   updateCourseFiles();
  // }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneNoController = TextEditingController(text: widget.phoneNumber);
    experienceController = TextEditingController(text: widget.experience);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    experienceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.certificatesURL);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    // double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(
                    width: width * 0.28,
                  ),
                  CustomText(
                    text: "Staff Detail",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              PhotoPicker(
                photoURL: widget.photoURL,
                from: From.detail,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomInputField(
                controller: nameController,
                hintText: "Edit the Name",
                icon: Icons.person_rounded,
                inputType: TextInputType.name,
                readOnly: true,
              ),
              CustomInputField(
                controller: emailController,
                hintText: "Edit the Email",
                icon: Icons.email_rounded,
                inputType: TextInputType.emailAddress,
                readOnly: true,
              ),
              CustomInputField(
                controller: phoneNoController,
                hintText: "Edit the Phone No",
                icon: Icons.numbers_rounded,
                inputType: TextInputType.phone,
                readOnly: true,
              ),
              CustomInputField(
                controller: experienceController,
                hintText: "Edit the Year of Experience",
                icon: Icons.grade_rounded,
                inputType: TextInputType.number,
                readOnly: true,
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CourseFiles(courseFiles: {}),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
