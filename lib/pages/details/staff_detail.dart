import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/page_header.dart';
import '../../components/home/student/course_files.dart';
import '../../model/user.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/add_staff/custom_input_field.dart';
import '../../components/add_staff/photo_picker.dart';

class StaffDetail extends ConsumerStatefulWidget {
  final UserModel staff;

  const StaffDetail({
    super.key,
    required this.staff,
  });

  @override
  ConsumerState<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends ConsumerState<StaffDetail> {
  Map<File, String> photo = {};
  TextEditingController nameController = TextEditingController(text: "...");
  TextEditingController emailController = TextEditingController(text: "...");
  TextEditingController phoneNoController = TextEditingController(text: "");
  TextEditingController staffIDController = TextEditingController(text: "");

  void initializeData() {
    nameController = TextEditingController(text: widget.staff.name);
    emailController = TextEditingController(text: widget.staff.email);
    phoneNoController =
        TextEditingController(text: widget.staff.phoneNumber.toString());
    staffIDController = TextEditingController(text: widget.staff.staffId);
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
    staffIDController.dispose();
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
              PageHeader(
                  tittle:
                      "${widget.staff.userRole == UserRole.admin ? "Admin" : ""} staff detail"),
              SizedBox(
                height: height * 0.04,
              ),
              PhotoPicker(
                photoURL: widget.staff.imagePath,
                from: From.detail,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomInputField(
                controller: staffIDController,
                hintText: "Staff ID",
                icon: Icons.grade_rounded,
                inputType: TextInputType.number,
                readOnly: true,
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

              SizedBox(
                height: height * 0.01,
              ),
              // CourseFiles(
              //     courseFiles: widget.certificatesURL,
              //     from: CourseFileListFrom.staffDetail,
              //     height: height * .4),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
