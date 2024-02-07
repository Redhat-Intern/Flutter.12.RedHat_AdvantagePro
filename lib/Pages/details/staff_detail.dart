import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Utilities/static_data.dart';
import '../../firebase/create/add_staff.dart';
import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

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

  Map<int, String> completionCount = {};

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
          .listen((event) {});
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
                    setter: setPhoto,
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
                          text: "Save Staff",
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
