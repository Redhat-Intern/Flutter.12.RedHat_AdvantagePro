import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redhat_v1/components/add_staff/send_email.dart';

import '../../providers/class/batch.dart';

Future<bool> createBatch({
  required Batch batch,
}) async {
  Map<String, dynamic> batchData = batch.toMap();

  String error = "";
  await FirebaseFirestore.instance
      .collection("batches")
      .doc(batch.name)
      .set(batchData)
      .onError((error, stackTrace) => error = error);

  for (var element in batch.students) {
    String regID =
        "${batch.name}STU${(batch.students.indexOf(element)+1).toString().padLeft(3, '0')}";
    Map<String, dynamic> studentData = element.toMap();
    studentData.addEntries([
      MapEntry("regID", regID),
      MapEntry("batchName", batch.name),
      MapEntry("certificateName", batch.certificateData["name"]),
      MapEntry("certificateImg", batch.certificateData["image"]),
    ]);

    await FirebaseFirestore.instance
        .collection("studentRequest")
        .doc(element.email)
        .set(studentData);
    await sendStudentEmail(
      receiverEmail: element.email,
      name: element.name,
      batchID: batch.name,
      registrationNo: regID,
    );
  }

  if (error == "") {
    return true;
  } else {
    return false;
  }
}

Future<bool> saveBatch({
  required Batch batch,
}) async {
  Map<String, dynamic> batchData = batch.toMap();

  String error = "";
  await FirebaseFirestore.instance
      .collection("savedBatches")
      .doc(batch.name)
      .set(batchData)
      .onError((error, stackTrace) => error = error);

  if (error == "") {
    return true;
  } else {
    return false;
  }
}
