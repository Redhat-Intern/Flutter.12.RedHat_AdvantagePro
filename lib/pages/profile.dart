import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/user_detail_provider.dart';
import '../components/profile/color_palette.dart';
import '../components/profile/theme_toggle.dart';
import '../functions/firebase_auth.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../components/profile/profile_tile.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = ref.watch(userDataProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

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
                padding: EdgeInsets.all(aspectRatio * 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorData.secondaryColor(1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(width),
                  child: Image.network(userData["photo"],
                      height: aspectRatio * 250,
                      width: aspectRatio * 250,
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Shimmer.fromColors(
                        baseColor: colorData.backgroundColor(.1),
                        highlightColor: colorData.secondaryColor(.1),
                        child: Container(
                          height: aspectRatio * 250,
                          width: aspectRatio * 250,
                          decoration: BoxDecoration(
                            color: colorData.secondaryColor(.5),
                            borderRadius: BorderRadius.circular(width),
                          ),
                        ),
                      );
                    }
                  }),
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
