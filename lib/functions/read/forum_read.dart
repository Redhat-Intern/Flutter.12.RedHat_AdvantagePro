import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/forum/chat.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../../model/forum.dart';
import '../../providers/forum_provider.dart';

List<ChatForum> fetchChatForums(
    {required snapshotData, required userData, required WidgetRef ref}) {
  List<ChatForum> chatForums = [];
  for (var all in snapshotData) {
    Map<String, dynamic> forumData = all.data();
    Map<String, dynamic> chatData = forumData;

    String id = all.id;
    List<String> members =
        List.from(forumData["members"]).map((e) => e.toString()).toList();

    String name = forumData["details"]["name"];
    String image;
    if (members.length > 2) {
      image = forumData["details"]["image"];
    } else {
      image = forumData["details"]["name"][0];
    }
    chatData.remove("details");
    chatData.remove("members");

    List<ChatMessage> chatMessages = [];

    chatData.forEach(
      (key, value) {
        chatMessages.add(
          value["text"] != null
              ? ChatMessage(
                  id: key,
                  name: value["name"],
                  type: MessageType.text,
                  from: value["from"],
                  time: DateTime.parse(value["time"]),
                  text: value["text"],
                  viewedBy: [],
                )
              : value["image"] != null
                  ? ChatMessage(
                      id: key,
                      name: value["name"],
                      type: MessageType.image,
                      from: value["from"],
                      time: DateTime.parse(value["time"]),
                      imageURL: value["image"],
                      viewedBy: [],
                    )
                  : ChatMessage(
                      id: key,
                      name: value["name"],
                      type: MessageType.file,
                      from: value["from"],
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

  Future(
      () => ref.read(forumDataProvider.notifier).updateChatForum(chatForums));

  return chatForums;
}
