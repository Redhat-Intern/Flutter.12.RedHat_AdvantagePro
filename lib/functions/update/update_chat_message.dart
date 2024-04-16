import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/forum.dart';
import '../../providers/forum_provider.dart';
import '../../providers/user_detail_provider.dart';

void uploadChat(
    {String? text,
    
    File? image,
    File? file,
    required WidgetRef ref,
    required int index}) async {
  Map<String, dynamic> userData = ref.watch(userDataProvider)!;
  List<ChatForum> chatForums = ref.watch(forumDataProvider);
  String currentTime = DateTime.now().toIso8601String();
  Map<String, dynamic> data = {};
  if (text != null) {
    data = {
      "${userData["email"]}|$currentTime": {
        "from": userData["email"],
        "name": userData["name"],
        "text": text,
        "time": currentTime
      }
    };
  } else if (image != null) {
    data = {
      "${userData["email"]}|$currentTime": {
        "name": userData["name"],
        "from": userData["email"],
        "image": text,
        "time": currentTime
      }
    };
  } else if (file != null) {
    data = {
      "${userData["email"]}|$currentTime": {
        "name": userData["name"],
        "from": userData["email"],
        "file": text,
        "time": currentTime
      }
    };
  }

  await FirebaseFirestore.instance
      .collection("forum")
      .doc(chatForums[index].id)
      .set(data, SetOptions(merge: true));
}
