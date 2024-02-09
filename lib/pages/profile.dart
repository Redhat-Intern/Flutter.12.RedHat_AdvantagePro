import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_detail_provider.dart';
import '../components/profile/color_palette.dart';
import '../components/profile/theme_toggle.dart';
import '../firebase/firebase_auth.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../components/profile/profile_tile.dart';

class Profile extends ConsumerWidget {
  Profile({super.key});

  final String email = AuthFB().currentUser!.email.toString();

  final Stream<DocumentSnapshot<Map<String, dynamic>>> userDataStream =
      FirebaseFirestore.instance
          .collection("users")
          .doc(AuthFB().currentUser!.email)
          .snapshots();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = ref.watch(userDataProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  ThemeToggle(),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      'assets/images/profile.png',
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              CustomText(
                text: userData["name"],
                size: sizeData.header,
                weight: FontWeight.w800,
                color: colorData.fontColor(.8),
              ),
              SizedBox(height: height * 0.005),
              CustomText(
                text: userData["email"],
                size: sizeData.regular,
                color: colorData.fontColor(.6),
              ),
              SizedBox(height: height * 0.05),
              const ColorPalette(),
              ProfileTile(
                  text: 'Edit Profile', icon: Icons.edit_outlined, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(
                  text: 'Help', icon: Icons.help_outline_outlined, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(text: 'History', icon: Icons.history, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(
                text: 'Logout',
                icon: Icons.logout_outlined,
                todo: () {
                  AuthFB().signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
