import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../functions/create/create_user.dart';
import '../../functions/create/generate_userdata.dart';
import '../../components/add_staff/custom_input_field.dart';
import '../../components/auth/loginsingup_shifter.dart';
import '../../components/common/back_button.dart';
import '../../components/common/footer.dart';
import '../../model/user.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';

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

  void _generateUserData() async {
    Map<String, dynamic>? userData =
        await generateUserData(context: context, id: idCtr.text.trim());
    if (userData != null) {
      setState(() {
        generatedData = userData;
        emailCtr.text = userData["email"];
        nameCtr.text = userData["name"];
      });
    }
  }

  void _createUser() async {
    setState(() {
      generatedData["name"] = nameCtr.text.trim();
      generatedData["password"] = passwordCtr.text.trim();
      generatedData["email"] = emailCtr.text.trim();
    });
    print(generatedData);

    await createUser(
      // ref: ref,
      email: emailCtr.text.trim(),
      password: passwordCtr.text.trim(),
      generatedData: UserModel.fromJson(generatedData),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    String hintText = "ID";
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
                        onTap: () => _generateUserData(),
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
                    onTap:
                        generatedData.isNotEmpty ? () => _createUser() : () {},
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
