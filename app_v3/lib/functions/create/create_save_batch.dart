import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/batch.dart';

Future<bool> createBatch({
  required Batch batch,
  required WidgetRef ref,
}) async {
  Map<String, dynamic> batchData = batch.toMap();

  try {
    await FirebaseFirestore.instance
        .collection("batches")
        .doc(batch.name.toUpperCase())
        .set({...batchData, "status": "live"});

    await FirebaseFirestore.instance
        .collection("savedBatches")
        .doc(batch.name.toUpperCase())
        .delete();

    for (var element in batch.students) {
      Map<String, dynamic> studentData = element.toMap();
      studentData.addEntries([
        MapEntry("batchName", batch.name),
        MapEntry("courseID", batch.courseData["name"].toString().toUpperCase()),
      ]);

      await FirebaseFirestore.instance
          .collection("requests")
          .doc(element.email)
          .set(studentData);
    }

    return true;
  } catch (exception) {
    return false;
  }
}

Future<bool> uniqueIDCheck({
  required String batchID,
  required String collName,
}) async {
  try {
    var data = await FirebaseFirestore.instance
        .collection(collName)
        .doc(batchID)
        .get();
    return data.exists;
  } catch (error) {
    return true;
  }
}

Future<bool> saveBatch({
  required Batch batch,
}) async {
  Map<String, dynamic> batchData = batch.toMap();
  try {
    await FirebaseFirestore.instance
        .collection("savedBatches")
        .doc(batch.name.toUpperCase())
        .set(batchData)
        .onError((error, stackTrace) => error = error);
    return true;
  } catch (e) {
    return false;
  }
}
