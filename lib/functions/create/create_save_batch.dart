import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redhat_v1/components/add_staff/send_email.dart';

import '../../model/batch.dart';

Future<bool> createBatch({
  required Batch batch,
}) async {
  Map<String, dynamic> batchData = batch.toMap();

  try {
    await FirebaseFirestore.instance
        .collection("batches")
        .doc(batch.name)
        .set(batchData);

    await FirebaseFirestore.instance
        .collection("certificates")
        .doc(batch.certificateData["name"])
        .collection("instances")
        .doc(batch.name)
        .set(batch.certificateData);

    for (var element in batch.staffs) {
      bool isAdmin = batch.adminStaff.keys.first.toString().toLowerCase() ==
          element.keys.first.toString().toLowerCase();
      String role = (isAdmin ? "admin" : "staff").toUpperCase();
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc("invitations")
          .set({
        element.values.first: {
          batch.name: {
            'message': 'You have been invited to join this batch as $role',
          }
        }
      }, SetOptions(merge: true));
    }

    for (var element in batch.students) {
      String regID =
          "${batch.name}STU${(batch.students.indexOf(element) + 1).toString().padLeft(3, '0')}";
      Map<String, dynamic> studentData = element.toMap();
      studentData.addEntries([
        MapEntry("regID", regID),
        MapEntry("batchName", batch.name),
        MapEntry("certificateID", batch.certificateData["name"]),
      ]);

      await FirebaseFirestore.instance
          .collection("studentRequest")
          .doc(element.email)
          .set(studentData);

      QuerySnapshot<Map<String, dynamic>> studentList = await FirebaseFirestore
          .instance
          .collection("students")
          .where("email", isEqualTo: element.email)
          .get();

      Future sendInvitation() async => await FirebaseFirestore.instance
              .collection("notifications")
              .doc("invitations")
              .set({
            element.email: {
              batch.name: {
                'message':
                    'Welcome to the cretification course of ${batch.certificateData["name"]}',
                'id': regID,
              }
            }
          }, SetOptions(merge: true));

      if (studentList.docs.isEmpty) {
        await sendStudentEmail(
          receiverEmail: element.email,
          name: element.name,
          batchID: batch.name,
          registrationNo: regID,
        );
        sendInvitation();
      } else {
        sendInvitation();
      }
    }
    return true;
  } catch (exception) {
    return false;
  }
}

Future<bool> saveBatch({
  required Batch batch,
}) async {
  Map<String, dynamic> batchData = batch.toMap();
  try {
    await FirebaseFirestore.instance
        .collection("savedBatches")
        .doc(batch.name)
        .set(batchData)
        .onError((error, stackTrace) => error = error);
    return true;
  } catch (e) {
    return false;
  }
}
