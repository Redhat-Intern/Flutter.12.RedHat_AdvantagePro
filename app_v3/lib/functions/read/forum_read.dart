import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/forum.dart';
import '../../providers/chat_scroll_provider.dart';
import '../../providers/forum_provider.dart';
import '../../utilities/static_data.dart';

MapEntry<List<ChatForum>, Map<String, bool>> fetchChatForums(
    {required snapshotData,
    required QueryDocumentSnapshot<Map<String, dynamic>>? statusSnap,
    required userData,
    required WidgetRef ref}) {
  List<ChatForum> chatForums = [];
  for (var all in snapshotData) {
    Map<String, dynamic> forumData = all.data();
    Map<String, dynamic> chatData = forumData;

    String id = all.id;
    Map<String, dynamic> members = Map.from(forumData["members"]);

    String name = forumData["details"]["name"];
    String image = "";

    if (members.length == 2) {
      String email =
          userData.userRole == UserRole.superAdmin ? "admin" : userData.email;
      members.forEach((key, value) {
        if (key.toLowerCase() != email.toLowerCase()) {
          name = value["name"];
          image = value["imagePath"];
        }
      });
    } else {
      image = forumData["details"]["image"];
    }
    chatData.remove("details");
    chatData.remove("members");

    List<ChatMessage> chatMessages = [];

    chatData.forEach(
      (key, value) {
        String senderName = members[value["from"]]["name"];
        chatMessages.add(
          value["text"] != null
              ? ChatMessage(
                  id: key,
                  name: senderName,
                  type: MessageType.text,
                  from: value["from"],
                  time: DateTime.parse(value["time"]),
                  text: value["text"],
                  viewedBy: [],
                )
              : value["type"] != null && value["type"] == "image"
                  ? ChatMessage(
                      id: key,
                      name: senderName,
                      type: MessageType.image,
                      from: value["from"],
                      time: DateTime.parse(value["time"]),
                      imageURL: value["file"],
                      viewedBy: [],
                    )
                  : value["type"] != null && value["type"] == "audio"
                      ? ChatMessage(
                          id: key,
                          name: senderName,
                          type: MessageType.audio,
                          from: value["from"],
                          time: DateTime.parse(value["time"]),
                          fileURL: value["file"],
                          viewedBy: [],
                        )
                      : value["type"] != null && value["type"] == "video"
                          ? ChatMessage(
                              id: key,
                              name: senderName,
                              type: MessageType.video,
                              from: value["from"],
                              time: DateTime.parse(value["time"]),
                              fileURL: value["file"],
                              viewedBy: [],
                            )
                          : ChatMessage(
                              id: key,
                              name: senderName,
                              type: MessageType.document,
                              from: value["from"],
                              specType: value["type"],
                              time: DateTime.parse(value["time"]),
                              fileURL: value["file"],
                              viewedBy: [],
                            ),
        );
      },
    );

    chatMessages.sort(
      (a, b) {
        DateTime dateA = a.time;
        DateTime dateB = b.time;

        return dateA.compareTo(dateB);
      },
    );

    ChatForum chatForum = ChatForum(
        id: id,
        name: name,
        imageURL: image,
        members: members,
        messages: chatMessages);

    chatForums.add(chatForum);
  }
  Map<String, bool> status = {};
  if (statusSnap != null) {
    status =
        statusSnap.data().map((key, value) => MapEntry(key, value as bool));
  }

  Future(() {
    ref.read(forumDataProvider.notifier).updateChatForum(chatForums);
    if (snapshotData != null) {
      ref.read(forumDataProvider.notifier).updateStatus(
          statusSnap!.data().map((key, value) => MapEntry(key, value as bool)));
    }
    ref.read(chatScrollProvider.notifier).jump();
  });

  return MapEntry(chatForums, status);
}
