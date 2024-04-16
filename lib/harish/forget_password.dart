// import 'package:flutter/material.dart';
// import 'package:redhat_v1/components/auth/logintext_field.dart';
// import 'package:redhat_v1/components/common/back_button.dart';
// import 'package:redhat_v1/components/common/text.dart';
// import 'package:redhat_v1/layout/auth.dart';
// import 'package:redhat_v1/pages/auth_pages/login.dart';
// import 'package:redhat_v1/utilities/theme/size_data.dart';

// class ForgetPasswordScreen extends StatelessWidget {
//   const ForgetPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     CustomSizeData sizeData = CustomSizeData.from(context);

//     double width = sizeData.width;
//     double height = sizeData.height;

//     Color fontColor(double opacity) =>
//         const Color(0XFF1C2136).withOpacity(opacity);
//     Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

//     return Scaffold(
//       backgroundColor: const Color(0xffDADEEC),
//       body: SafeArea(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               top: height * 0.02,
//               left: width * 0.04,
//               child: const CustomBackButton(
//                 tomove: Login(),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Image(
//                 height: height * .185,
//                 image: const AssetImage(
//                   "assets/images/redhat.png",
//                 ),
//               ),
//             ),
//             Container(
//               width: width,
//               padding: EdgeInsets.only(
//                   left: width * 0.05, right: width * 0.05, top: height * 0.2),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     text: "Login",
//                     size: sizeData.superHeader,
//                     color: fontColor(1),
//                     weight: FontWeight.bold,
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   CustomText(
//                     text: "Please signin in to continue",
//                     size: sizeData.header,
//                     color: fontColor(.6),
//                     weight: FontWeight.bold,
//                   ),
//                   SizedBox(
//                     height: height * 0.04,
//                   ),
//                   LoginTextField(
//                     icon: Icons.email_outlined,
//                     labelText: "EMAIL",
//                     controller: emailController,
//                     bottomMargin: 0.025,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
