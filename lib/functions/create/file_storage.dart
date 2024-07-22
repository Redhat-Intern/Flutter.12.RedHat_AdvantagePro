import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../utilities/console_logger.dart';

Future<String?> uploadFileToStorage(File file, String path) async {
  try {
    UploadTask uploadTask = FirebaseStorage.instance.ref(path).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    ConsoleLogger.error("File upload error: $e", from: "uploadFileToStorage");
    return null;
  }
}
