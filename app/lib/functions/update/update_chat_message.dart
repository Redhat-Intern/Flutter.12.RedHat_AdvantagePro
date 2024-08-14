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

void uploadChat({
  String? text,
  File? file,
  String? metadata,
  String? fileExtension,
  required WidgetRef ref,
  required int index,
}) async {
  UserModel userData = ref.watch(userDataProvider).key;
  List<ChatForum> chatForums = ref.watch(forumDataProvider).key;
  String currentTime = DateTime.now().toIso8601String();
  Map<String, dynamic> data = {};

  if (text != null) {
    data = {
      "${userData.email}|$currentTime": {
        "from":
            userData.userRole == UserRole.superAdmin ? "admin" : userData.email,
        "text": text,
        "time": currentTime
      }
    };
  } else {
    await FirebaseFirestore.instance
        .collection("forum")
        .doc(chatForums[index].id)
        .set({
      "${userData.email}|$currentTime": {
        "from":
            userData.userRole == UserRole.superAdmin ? "admin" : userData.email,
        "file": '',
        "type": metadata,
        "time": currentTime
      }
    }, SetOptions(merge: true));

    String imagePath =
        'forum/${chatForums[index].id}/${userData.email}|$currentTime.$fileExtension';
    String? downloadUrl = await uploadFileToStorage(file!, imagePath);

    if (downloadUrl != null) {
      data = {
        "${userData.email}|$currentTime": {
          "from": userData.userRole == UserRole.superAdmin
              ? "admin"
              : userData.email,
          "file": downloadUrl,
          "type": metadata,
          "time": currentTime
        }
      };
    } else {
      ConsoleLogger.error("Image upload failed", from: "uploadChat");
      return;
    }
  }

  await FirebaseFirestore.instance
      .collection("forum")
      .doc(chatForums[index].id)
      .set(data, SetOptions(merge: true));
}
