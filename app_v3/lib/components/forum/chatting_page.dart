import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/forum.dart';
import '../../model/user.dart';
import '../../providers/chat_scroll_provider.dart';
import '../../providers/forum_provider.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import 'chat_page/chat_message.dart';
import 'chat_page/chat_page_header.dart';
import 'chat_page/chat_textfield.dart';

class ChattingPage extends ConsumerStatefulWidget {
  const ChattingPage({super.key, required this.index, this.senderID});
  final int index;
  final String? senderID;

  @override
  ConsumerState<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future(() {
      controller = ref.watch(chatScrollProvider);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  @override
  void didUpdateWidget(covariant ChattingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  void deleteChat({required String chatID, required String forumID}) async {
    await FirebaseFirestore.instance
        .collection("forum")
        .doc(forumID)
        .set({chatID: FieldValue.delete()}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    ChatForum chatForum = ref.watch(forumDataProvider).key[widget.index];
    UserModel userData = ref.watch(userDataProvider).key;
    Map<String, Status> statusMap = ref.watch(forumDataProvider).value;
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double width = sizeData.width;

    Status? singleStatus;
    int? count;
    if (chatForum.members.length == 2) {
      singleStatus = statusMap[chatForum.members.entries
              .where((data) =>
                  data.key !=
                  (userData.userRole == UserRole.superAdmin
                      ? "admin"
                      : userData.email))
              .first
              .key] ??
          Status.offline;
    } else {
      count = chatForum.members.entries
          .where((data) =>
              data.key !=
                  (userData.userRole == UserRole.superAdmin
                      ? "admin"
                      : userData.email) &&
              statusMap[data.key] == Status.online)
          .length;
    }

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              ChatFieldHeader(
                name: chatForum.name,
                imageURL: chatForum.imageURL,
                status: singleStatus,
                liveCount: count,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: ListView.builder(
                    controller: controller,
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.03,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: chatForum.messages.length,
                    itemBuilder: (context, index) {
                      ChatMessage message = chatForum.messages[index];
                      return ChatTile(
                        previousSenderId:
                            index > 0 ? chatForum.messages[index - 1].from : '',
                        senderId: message.from,
                        senderImage: chatForum.members[message.from]
                            ["imagePath"],
                        name: message.name,
                        receiverId: message.to ?? "all",
                        isGroup: chatForum.members.length > 2,
                        time: message.time,
                        type: message.type,
                        message: message.text,
                        imageURL: message.imageURL,
                        fileURL: message.fileURL,
                        specType: message.specType,
                        deleteChat: () {
                          deleteChat(
                            chatID: chatForum.messages[index].id,
                            forumID: chatForum.id,
                          );
                        },
                      );
                    }),
              ),
              ChatTextField(
                index: widget.index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
