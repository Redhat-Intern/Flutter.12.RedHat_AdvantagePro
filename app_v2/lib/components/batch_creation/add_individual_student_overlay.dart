import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/student.dart';
import '../../providers/create_batch_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../add_staff/custom_input_field.dart';
import '../common/text.dart';

class AddIndividualStudentOverlay extends ConsumerStatefulWidget {
  final From from;
  final Student? data;

  const AddIndividualStudentOverlay({
    super.key,
    required this.from,
    this.data,
  });

  @override
  ConsumerState<AddIndividualStudentOverlay> createState() =>
      _AddIndividualStudentOverlayState();
}

class _AddIndividualStudentOverlayState
    extends ConsumerState<AddIndividualStudentOverlay> {
  TextEditingController registrationIDCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController phoneNoCtr = TextEditingController();
  TextEditingController occupationDetailCtr = TextEditingController();

  StudentOcc occupation = StudentOcc.college;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.from == From.edit) {
        registrationIDCtr.text = widget.data!.registrationID;
        nameCtr.text = widget.data!.name;
        emailCtr.text = widget.data!.email;
        phoneNoCtr.text = widget.data!.phoneNo;
        occupation = widget.data!.occupation;
        occupationDetailCtr.text = widget.data!.occDetail;
      }
    });
  }

  @override
  void dispose() {
    registrationIDCtr.dispose();
    nameCtr.dispose();
    emailCtr.dispose();
    phoneNoCtr.dispose();
    occupationDetailCtr.dispose();
    super.dispose();
  }

  void addStudent() {
    if (registrationIDCtr.text != "" &&
        nameCtr.text != "" &&
        emailCtr.text != "" &&
        phoneNoCtr.text != "" &&
        occupationDetailCtr.text != "") {
      Student data = Student(
        registrationID: registrationIDCtr.text,
        name: nameCtr.text,
        email: emailCtr.text,
        phoneNo: phoneNoCtr.text,
        occupation: occupation,
        occDetail: occupationDetailCtr.text,
      );

      if (widget.from == From.edit) {
        ref.read(createBatchProvider.notifier).modifyStudent(student: data);
        Navigator.pop(context);
      } else {
        bool check =
            ref.read(createBatchProvider.notifier).addStudent(student: data);
        if (check) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text("RegistrationID must me *UNIQUE*")),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Kindly enter all the details")),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return AlertDialog(
      backgroundColor: colorData.backgroundColor(1),
      elevation: 0,
      scrollable: true,
      title: CustomText(
        text: "Add Student Individualy",
        size: sizeData.medium,
        color: colorData.fontColor(.8),
        weight: FontWeight.w600,
      ),
      alignment: Alignment.center,
      titlePadding: EdgeInsets.only(
        left: width * .15,
        top: height * .03,
        bottom: height * 0.02,
      ),
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        CustomInputField(
          controller: registrationIDCtr,
          hintText: "Enter the Registration ID",
          icon: Icons.badge_rounded,
          inputType: TextInputType.text,
          readOnly: widget.from == From.edit,
        ),
        CustomInputField(
          controller: nameCtr,
          hintText: "Enter the Name",
          icon: Icons.person_rounded,
          inputType: TextInputType.text,
        ),
        CustomInputField(
          controller: emailCtr,
          hintText: "Enter the Email",
          icon: Icons.email_rounded,
          inputType: TextInputType.emailAddress,
        ),
        CustomInputField(
          controller: phoneNoCtr,
          hintText: "Enter the PhoneNo",
          icon: Icons.numbers_rounded,
          inputType: TextInputType.number,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: StudentOcc.values
              .map((e) => GestureDetector(
                    onTap: () => setState(() {
                      occupation = e;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.025, vertical: height * 0.008),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: occupation == e
                              ? [
                                  colorData.primaryColor(.4),
                                  colorData.primaryColor(1),
                                ]
                              : [
                                  colorData.secondaryColor(.4),
                                  colorData.secondaryColor(1),
                                ],
                        ),
                      ),
                      child: CustomText(
                        text: e.name,
                        size: sizeData.regular,
                        color: occupation == e
                            ? colorData.secondaryColor(1)
                            : colorData.fontColor(.6),
                        weight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
        CustomInputField(
          controller: occupationDetailCtr,
          hintText: "Enter the occupation detail",
          icon: Icons.work_rounded,
          inputType: TextInputType.text,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        GestureDetector(
          onTap: () => addStudent(),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.008,
              horizontal: width * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorData.primaryColor(.4),
                  colorData.primaryColor(1),
                ],
              ),
            ),
            child: CustomText(
              text: widget.from == From.edit ? "Save Changes" : "Add Student",
              size: sizeData.regular,
              color: colorData.secondaryColor(1),
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
