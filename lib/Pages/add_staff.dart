import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/add_staff/send_email.dart';

import '../firebase/create/add_staff.dart';
import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';

import '../components/add_staff/add_staff_certificate.dart';
import '../components/add_staff/custom_input_field.dart';
import '../components/add_staff/photo_picker.dart';
import '../components/common/back_button.dart';
import '../components/common/text.dart';

class AddStaff extends ConsumerStatefulWidget {
  const AddStaff({super.key});

  @override
  ConsumerState<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends ConsumerState<AddStaff> {
  Map<File, String> photo = {};
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  List<Map<File, Map<String, dynamic>>> certificates = [];

  Map<int, String> completionCount = {};

  void setPhoto(File photo, String photoName) {
    setState(() {
      this.photo = {photo: photoName};
    });
  }

  bool hasDuplicate({required Map<File, Map<String, dynamic>> certificate}) {
    for (var element in certificates) {
      if (element.values.first["name"] == certificate.values.first["name"]) {
        return false;
      }
    }
    return true;
  }

  void handleCertificate(
      {required Map<File, Map<String, dynamic>> certificate,
      required bool set}) {
    setState(() {
      if (set) {
        if (hasDuplicate(certificate: certificate)) {
          certificates.add(certificate);
        }
      } else {
        certificates.remove(certificate);
      }
    });
  }

  void addStaffValidate() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        experienceController.text.isEmpty ||
        photo.isEmpty ||
        certificates.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Kindly enter all the data")));
    } else {
      setState(() {
        completionCount = {0: "Started"};
      });
      addStaff(
              photo: photo,
              nameController: nameController,
              emailController: emailController,
              phoneNoController: phoneNoController,
              experienceController: experienceController,
              certificates: certificates)
          .listen((event) {
        setState(() {
          if (event.keys.first == 1) {
            sendEmail(
                imageURL: event.values.first,
                receiverEmail: emailController.text,
                name: nameController.text,
                registrationNo: "RHCSA123");
            completionCount = {1: "Photo uploaded"};
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
    experienceController.dispose();
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
                  Row(
                    children: [
                      const CustomBackButton(),
                      SizedBox(
                        width: width * 0.28,
                      ),
                      CustomText(
                        text: "Add Staff",
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
                    setter: setPhoto,
                  ),
                  SizedBox(
                    height: height * 0.02,
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
                  CustomInputField(
                    controller: experienceController,
                    hintText: "Enter the Year of Experience",
                    icon: Icons.grade_rounded,
                    inputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  AddStaffCertificates(
                    handleCertificate: handleCertificate,
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
                            color: colorData.secondaryColor(.5),
                            blurRadius: 400,
                            spreadRadius: 400,
                          ),
                        ]),
                        child: Center(
                          child: Container(
                            // width: width * .5,
                            height: height * .23,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorData.primaryColor(.2),
                                    colorData.primaryColor(.6)
                                  ]),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.06,
                                ),
                                CircularProgressIndicator.adaptive(
                                  strokeWidth: 8,
                                  strokeAlign: 5,
                                  strokeCap: StrokeCap.round,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation(
                                      colorData.primaryColor(1)),
                                  value: completionCount.keys.first * 0.33,
                                ),
                                SizedBox(
                                  height: height * 0.06,
                                ),
                                CustomText(
                                  text: completionCount.values.first,
                                  size: sizeData.medium,
                                  color: colorData.secondaryColor(1),
                                  weight: FontWeight.w600,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
