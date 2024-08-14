import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/forum_category_provider.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../components/common/page_header.dart';
import '../components/forum/chat.dart';
import '../components/forum/forum_header.dart';
import '../functions/read/forum_read.dart';
import '../model/forum.dart';
import '../model/user.dart';
import '../providers/user_detail_provider.dart';
import '../utilities/theme/size_data.dart';

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
              stream:
                  FirebaseFirestore.instance.collection("forum").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<ChatForum> chatForums = fetchChatForums(
                      snapshotData: snapshot.data!.docs.where((data) {
                        if (data.id != "status") {
                          List<String> memberEmail =
                              Map<String, dynamic>.from(data.data()["members"])
                                  .keys
                                  .toList();
                          return (memberEmail.contains(userData.email) ||
                              (userData.userRole == UserRole.superAdmin &&
                                  memberEmail.contains("admin")));
                        } else {
                          return false;
                        }
                      }),
                      statusSnap: snapshot.data!.docs
                          .where((data) => data.id == "status")
                          .firstOrNull,
                      userData: userData,
                      ref: ref);

                  ForumCategory forumCategory =
                      ref.watch(forumCategoryProvider).key;

                  if (forumCategory == ForumCategory.groups) {
                    chatForums = chatForums
                        .where((data) => data.members.length > 2)
                        .toList();
                  } else if (forumCategory == ForumCategory.staffs) {
                    chatForums = chatForums
                        .where((data) => data.members.values
                            .where((data) =>
                                Map<String, dynamic>.from(data)["userRole"] ==
                                    "staff" ||
                                Map<String, dynamic>.from(data)["userRole"] ==
                                    "admin")
                            .isNotEmpty)
                        .toList();
                  } else if (forumCategory == ForumCategory.students) {
                    chatForums = chatForums
                        .where((data) => data.members.values
                            .where((data) =>
                                Map<String, dynamic>.from(data)["userRole"] ==
                                "student")
                            .isNotEmpty)
                        .toList();
                  }

                  String? searchString = ref.watch(forumCategoryProvider).value;

                  if (searchString != null && searchString.isNotEmpty) {
                    chatForums = chatForums
                        .where((data) => data.name
                            .toLowerCase()
                            .contains(searchString.toLowerCase()))
                        .toList();
                  }

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
