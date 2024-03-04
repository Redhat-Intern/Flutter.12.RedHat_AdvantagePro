import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/text.dart';
import '../components/forum/chat.dart';
import '../components/forum/forum_header.dart';
import '../functions/read/forum_read.dart';
import '../model/forum.dart';
import '../providers/forum_category_provider.dart';
import '../providers/user_detail_provider.dart';
import '../providers/user_select_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/menu_button.dart';

class Forum extends ConsumerWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ForumCategory category = ref.watch(forumCategoryProvider);
    UserRole userRole = ref.watch(userRoleProvider)!;
    Map<String, dynamic> userData = ref.watch(userDataProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
          children: [
            const MenuButton(),
            const Spacer(),
            CustomText(
              text: "FORUM",
              size: sizeData.header,
              color: colorData.fontColor(1),
              weight: FontWeight.w600,
            ),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: height * 0.02,
        ),
        const ForumHeader(),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("forum")
                  .where("members",
                      arrayContains: userRole == UserRole.admin
                          ? 'admin'
                          : userData["email"].toString().trim())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ChatForum> chatForums = fetchChatForums(
                      snapshotData: snapshot.data!.docs,
                      userData: userData,
                      ref: ref);

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    itemCount: chatForums.length,
                    itemBuilder: (context, index) {
                      return Chat(
                        data: chatForums[index],
                        index: index,
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }
}
