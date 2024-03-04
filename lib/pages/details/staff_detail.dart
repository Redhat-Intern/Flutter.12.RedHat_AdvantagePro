import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/page_header.dart';
import '../../components/home/student/course_files.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/add_staff/custom_input_field.dart';
import '../../components/add_staff/photo_picker.dart';

class StaffDetail extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String experience;
  final Map<String, dynamic> certificatesURL;
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

  void initializeData() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneNoController = TextEditingController(text: widget.phoneNumber);
    experienceController = TextEditingController(text: widget.experience);
  }

  @override
  void initState() {
    super.initState();
    initializeData();
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
    CustomSizeData sizeData = CustomSizeData.from(context);

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
              const PageHeader(tittle: "staff detail"),
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
              CourseFiles(
                  courseFiles: widget.certificatesURL,
                  from: CourseFileListFrom.staffDetail,
                  height: height * .4),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
