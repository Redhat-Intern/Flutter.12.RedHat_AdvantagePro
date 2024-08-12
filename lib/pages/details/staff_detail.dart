import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/functions/read/course_data.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';
import 'package:redhat_v1/utilities/console_logger.dart';
import 'package:redhat_v1/utilities/theme/color_data.dart';

import '../../components/common/page_header.dart';
import '../../components/common/shimmer_box.dart';
import '../../components/common/text.dart';
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

  void setAccess({required UserRole userRole}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.staff.email)
        .set({"userRole": userRole.name}, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
              "${widget.staff.name} access is modified to be ${userRole.name}"),
        ),
      ),
    );
    Navigator.pop(context);
  }

  void deleteStaff() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.staff.email)
        .delete()
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("STAFF: ${widget.staff.name} is deleted"),
          ),
        ),
      );
      Navigator.pop(context);
    });
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
    CustomColorData colorData = CustomColorData.from(ref);
    UserModel userModel = ref.watch(userDataProvider).key;

    double height = sizeData.height;
    double width = sizeData.width;

    bool isAdmin = widget.staff.userRole == UserRole.admin;

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
                tittle: "${isAdmin ? "Admin" : ""} staff detail",
                isMenuButton: false,
                secondaryWidget: userModel.userRole == UserRole.superAdmin
                    ? Center(
                        child: GestureDetector(
                          onTap: () => deleteStaff(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.008,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red,
                            ),
                            child: CustomText(
                              text: "DELETE",
                              size: sizeData.regular,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
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
              if (userModel.userRole == UserRole.superAdmin)
                Center(
                  child: GestureDetector(
                    onTap: () => setAccess(
                        userRole: isAdmin ? UserRole.staff : UserRole.admin),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.008,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            isAdmin ? Colors.red : colorData.primaryColor(.8),
                      ),
                      child: CustomText(
                        text: isAdmin
                            ? "REMOVE ADMIN ACCESS"
                            : "SET ADMIN ACCESS",
                        size: sizeData.regular,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: height * 0.02,
              ),
              CourseFileLoader(filesData: widget.staff.courses!),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseFileLoader extends ConsumerStatefulWidget {
  const CourseFileLoader({super.key, required this.filesData});
  final Map<String, dynamic> filesData;

  @override
  ConsumerState<CourseFileLoader> createState() => _CourseFileLoaderState();
}

class _CourseFileLoaderState extends ConsumerState<CourseFileLoader> {
  Map<File, Map<String, dynamic>>? courseFiles;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    Map<File, Map<String, dynamic>> courseFilesTemp =
        await CourseService(ref: ref).getFileMap(widget.filesData);
    if (mounted) {
      setState(() {
        courseFiles = courseFilesTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return courseFiles != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width * .02),
            child: CourseFiles(
              courseFiles: courseFiles!,
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(
              children: List.generate(
                2,
                (index) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  margin: EdgeInsets.only(bottom: height * 0.015),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
          );
  }
}
