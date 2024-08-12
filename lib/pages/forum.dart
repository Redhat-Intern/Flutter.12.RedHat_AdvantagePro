import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/page_header.dart';
import '../components/common/text.dart';
import '../components/forum/chat.dart';
import '../components/forum/forum_header.dart';
import '../functions/read/forum_read.dart';
import '../model/forum.dart';
import '../model/user.dart';
import '../providers/user_detail_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/menu_button.dart';

class Forum extends ConsumerStatefulWidget {
  const Forum({super.key});

  @override
  ConsumerState<Forum> createState() => ForumState();
}

class ForumState extends ConsumerState<Forum> {
  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider).key;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Column(
      children: [
        const PageHeader(
          tittle: "FORUM",
          isMenuButton: true,
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
                      arrayContains: userData.userRole == UserRole.admin
                          ? 'admin'
                          : userData.email)
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
