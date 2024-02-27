import '../utilities/static_data.dart';

class ChatMessage {
  String id;
  String from;
  String name;
  MessageType type;
  String? to;
  String? text;
  String? imageURL;
  String? fileURL;
  DateTime time;
  List<String> viewedBy;

  ChatMessage({
    required this.id,
    required this.from,
    required this.time,
    required this.viewedBy,
    required this.type,
    required this.name,
    this.to,
    this.text,
    this.imageURL,
    this.fileURL,
  });
}

class ChatForum {
  String id;
  String name;
  String imageURL;
  List<String> members;
  List<ChatMessage> messages;

  ChatForum({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.members,
    required this.messages,
  });
}
