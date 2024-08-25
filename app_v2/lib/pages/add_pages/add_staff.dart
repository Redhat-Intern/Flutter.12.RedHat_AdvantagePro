import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../components/add_staff/add_staff_courses.dart';
import '../../components/common/page_header.dart';
import '../../utilities/static_data.dart';
import '../../functions/create/add_staff.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/add_staff/custom_input_field.dart';
import '../../components/add_staff/photo_picker.dart';
import '../../components/common/text.dart';

class AddStaff extends ConsumerStatefulWidget {
  const AddStaff({super.key});

  @override
  ConsumerState<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends ConsumerState<AddStaff> {
  Map<File, String> photo = {};
  bool isAdmin = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController staffIDController = TextEditingController();
  List<Map<File, Map<String, dynamic>>> courses = [];

  Map<int, String> completionCount = {};

  void setPhoto(File photo, String photoName) {
    setState(() {
      this.photo = {photo: photoName};
    });
  }

  bool hasDuplicate({required Map<File, Map<String, dynamic>> course}) {
    for (var element in courses) {
      if (element.values.first["name"] == course.values.first["name"]) {
        return false;
      }
    }
    return true;
  }

  void handleCourse(
      {required Map<File, Map<String, dynamic>> course, required bool set}) {
    setState(() {
      if (set) {
        if (hasDuplicate(course: course)) {
          courses.add(course);
        }
      } else {
        courses.remove(course);
      }
    });
  }

  void addStaffValidate() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        staffIDController.text.isEmpty ||
        photo.isEmpty ||
        courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text("Kindly enter all the data"))));
    } else if (await checkIdMatch(staffIDController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text("Staff ID already exits"))));
    } else {
      setState(() {
        completionCount = {0: "Started uploading basic details"};
      });
      addStaff(
        photo: photo,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNo: phoneNoController.text.trim(),
        staffId: staffIDController.text.trim(),
        isAdmin: isAdmin,
        courses: courses,
      ).listen((event) {
        setState(() {
          if (event.keys.first == 1) {
            completionCount = {1: "Uploading courses"};
          } else if (event.keys.first == 3) {
            completionCount = event;
            Navigator.pop(context);
          }
        });
      });
    }
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(tittle: "add staff", isMenuButton: false),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  PhotoPicker(
                    setter: setPhoto,
                    from: From.add,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomInputField(
                    controller: staffIDController,
                    hintText: "Enter the Staff ID",
                    icon: Icons.badge_rounded,
                    inputType: TextInputType.text,
                  ),
                  CustomInputField(
                    controller: nameController,
                    hintText: "Enter the Name",
                    icon: Icons.person_rounded,
                    inputType: TextInputType.name,
                  ),
                  CustomInputField(
                    controller: emailController,
                    hintText: "Enter the Email",
                    icon: Icons.email_rounded,
                    inputType: TextInputType.emailAddress,
                  ),
                  CustomInputField(
                    controller: phoneNoController,
                    hintText: "Enter the Phone No",
                    icon: Icons.numbers_rounded,
                    inputType: TextInputType.phone,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() => isAdmin = !isAdmin),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: height * 0.008,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isAdmin
                              ? colorData.primaryColor(.8)
                              : colorData.secondaryColor(0.4),
                        ),
                        child: CustomText(
                          text: "SET ADMIN ACCESS",
                          size: sizeData.regular,
                          color: isAdmin
                              ? Colors.white
                              : colorData.primaryColor(1),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  AddStaffCourses(
                    handleCourse: handleCourse,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => addStaffValidate(),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.008),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorData.secondaryColor(.5),
                        ),
                        child: CustomText(
                          text: "Add Staff",
                          size: sizeData.medium,
                          color: colorData.fontColor(.8),
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
              completionCount.isEmpty
                  ? const SizedBox()
                  : Center(
                      child: Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: colorData.secondaryColor(.8),
                            blurRadius: 400,
                            spreadRadius: 400,
                          ),
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/json/uploading.json",
                              width: width * .7,
                            ),
                            Lottie.asset(
                              "assets/json/loadingProgress.json",
                              width: width * .5,
                            ),
                            SizedBox(
                              height: height * 0.06,
                            ),
                            SizedBox(
                              width: width * .7,
                              child: CustomText(
                                text: completionCount.values.first,
                                size: sizeData.medium,
                                color: colorData.primaryColor(1),
                                weight: FontWeight.w600,
                                maxLine: 3,
                                align: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.1,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
