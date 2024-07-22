import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/forum.dart';
import '../../model/user.dart';
import '../../providers/forum_provider.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/console_logger.dart';
import '../../utilities/static_data.dart';
import '../create/file_storage.dart';

void uploadChat(
    {String? text,
    File? image,
    File? file,
    required MessageType type,
    required WidgetRef ref,
    required int index}) async {
  UserModel userData = ref.watch(userDataProvider);
  List<ChatForum> chatForums = ref.watch(forumDataProvider);
  String currentTime = DateTime.now().toIso8601String();
  Map<String, dynamic> data = {};

  if (type == MessageType.text) {
    data = {
      "${userData.email}|$currentTime": {
        "from": userData.email,
        "name": userData.name,
        "text": text,
        "time": currentTime
      }
    };
  } else if (type == MessageType.image) {
    String imagePath = 'uploads/images/${userData.email}/$currentTime';
    String? downloadUrl = await uploadFileToStorage(image!, imagePath);

    if (downloadUrl != null) {
      data = {
        "${userData.email}|$currentTime": {
          "name": userData.name,
          "from": userData.email,
          "image": downloadUrl,
          "time": currentTime
        }
      };
    } else {
      ConsoleLogger.error("Image upload failed", from: "uploadChat");
      return;
    }
  } else if (type == MessageType.file) {
    String filePath = 'uploads/files/${userData.email}/$currentTime';
    String? downloadUrl = await uploadFileToStorage(file!, filePath);

    if (downloadUrl != null) {
      data = {
        "${userData.email}|$currentTime": {
          "name": userData.name,
          "from": userData.email,
          "file": downloadUrl,
          "time": currentTime
        }
      };
    } else {
      ConsoleLogger.error("File upload failed", from: "uploadChat");
      return;
    }
  }

  await FirebaseFirestore.instance
      .collection("forum")
      .doc(chatForums[index].id)
      .set(data, SetOptions(merge: true));
}
