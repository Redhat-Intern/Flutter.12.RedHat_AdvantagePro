
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_shifter.dart';
import '../../providers/user_select_provider.dart';
import '../../components/add_staff/custom_input_field.dart';
import '../../components/auth/loginsingup_shifter.dart';
import '../../components/common/back_button.dart';
import '../../components/common/footer.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../firebase/firebase_auth.dart';

import '../../components/common/text.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  TextEditingController idCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  Map<String, dynamic> generatedData = {};

  @override
  void dispose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    idCtr.dispose();
    nameCtr.dispose();
    super.dispose();
  }

  void generateUserData(
      {required double textSize,
      required Color textColor,
      required Color backgroundColor}) async {
    UserRole role = ref.watch(userRoleProvider)!;
    String colName =
        role == UserRole.staffs ? "staffRequest" : "studentRequest";
    QuerySnapshot<Map<String, dynamic>> queryData = await FirebaseFirestore
        .instance
        .collection(colName)
        .where("regID", isEqualTo: idCtr.text.toString())
        .get();
    if (queryData.docs.isNotEmpty) {
      setState(() {
        Map<String, dynamic> data =
            Map.fromEntries(queryData.docs.first.data().entries);
        generatedData = data;
        emailCtr.text = data["email"];
        nameCtr.text = data["name"];
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: CustomText(
            text:
                "The Provided ${role.name.toString().toUpperCase()} ID is not available!",
            maxLine: 3,
            align: TextAlign.center,
            color: textColor,
            size: textSize,
            weight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  void loginUser(
      {required double textSize,
      required Color textColor,
      required Color backgroundColor}) {
    UserRole role = ref.watch(userRoleProvider)!;
    setState(() {
      generatedData["name"] = nameCtr.text;
      generatedData["password"] = passwordCtr.text;
    });
    AuthFB()
        .createUserWithEmailAndPassword(
      email: emailCtr.text,
      password: passwordCtr.text,
    )
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(emailCtr.text)
          .set({"role": role.name.toString()});
      FirebaseFirestore.instance
          .collection(role.name.toString())
          .doc(emailCtr.text)
          .set(generatedData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthShifter(),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: CustomText(
            text: error.message.toString(),
            maxLine: 3,
            align: TextAlign.center,
            color: textColor,
            size: textSize,
            weight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    UserRole? role = ref.watch(userRoleProvider);
    String hintText = role == UserRole.staffs ? "STAFF ID" : "STUDENT ID";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffDADEEC),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: height * 0.02,
              left: width * 0.04,
              child: const CustomBackButton(),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image(
                height: height * .185,
                image: const AssetImage("assets/images/redhat.png"),
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: height * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Signup",
                    size: sizeData.superHeader,
                    color: fontColor(1),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomText(
                    text: "Create a account to continue",
                    size: sizeData.header,
                    color: fontColor(.6),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomInputField(
                          icon: Icons.fingerprint_rounded,
                          controller: idCtr,
                          hintText: hintText,
                          inputType: TextInputType.text,
                          bottomMar: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => generateUserData(
                          textColor: fontColor(.8),
                          textSize: sizeData.regular,
                          backgroundColor: secondaryColor(1),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.008,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: secondaryColor(.5)),
                          child: CustomText(
                            text: "GENERATE",
                            weight: FontWeight.bold,
                            color: primaryColors[0],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: "Enter the $hintText and generate to signup!",
                      weight: FontWeight.w700,
                      color: const Color.fromARGB(255, 80, 143, 82),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CustomInputField(
                    controller: nameCtr,
                    hintText: "NAME",
                    icon: Icons.person_rounded,
                    inputType: TextInputType.text,
                    readOnly: generatedData.isEmpty,
                  ),
                  CustomInputField(
                    controller: emailCtr,
                    hintText: "EMAIL",
                    icon: Icons.email_rounded,
                    inputType: TextInputType.emailAddress,
                    readOnly: true,
                  ),
                  CustomInputField(
                    controller: passwordCtr,
                    hintText: "PASSWORD",
                    icon: Icons.password_rounded,
                    inputType: TextInputType.visiblePassword,
                    readOnly: generatedData.isEmpty,
                    visibleText: false,
                  ),
                  GestureDetector(
                    onTap: generatedData.isNotEmpty
                        ? () => loginUser(
                              textColor: fontColor(.8),
                              textSize: sizeData.regular,
                              backgroundColor: secondaryColor(1),
                            )
                        : () {},
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: Durations.medium4,
                        margin: EdgeInsets.only(top: height * 0.04),
                        padding: EdgeInsets.symmetric(vertical: height * .0125),
                        width: width * 0.325,
                        decoration: BoxDecoration(
                          color: primaryColors[0]
                              .withOpacity(generatedData.isNotEmpty ? 1 : .5),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: generatedData.isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: primaryColors[0].withOpacity(.2),
                                    blurRadius: 12,
                                    offset: const Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: primaryColors[0].withOpacity(.2),
                                    blurRadius: 16,
                                    offset: const Offset(4, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          weight: FontWeight.bold,
                          text: "SIGNUP",
                          size: sizeData.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const LoginSingupShifter(shifter: LoginSignup.singup),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
