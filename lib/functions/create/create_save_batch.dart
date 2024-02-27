import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';

import '../../components/add_staff/send_email.dart';
import '../../model/batch.dart';

Future<bool> createBatch({
  required Batch batch,
  required WidgetRef ref,
}) async {
  Map<String, dynamic> batchData = batch.toMap();
  Map<String, dynamic> userData = ref.watch(userDataProvider)!;

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

    List<String> members = ['admin'];

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

      await FirebaseFirestore.instance
          .collection("staffs")
          .doc(element.values.first.toString().trim())
          .set({
        "batches": FieldValue.arrayUnion([batch.name])
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("forum")
          .doc("${element.values.first.toString().trim()}|admin")
          .set({
        "members": ["admin", element.values.first.toString().trim()],
        "details": {
          "name": 'admin',
        },
        "admin|${DateTime.now().toIso8601String()}": {
          "text":
              "Welcome aboard to our dedicated staff joining the new batch ${batch.name} at Vectra Advantage Pro! Wishing you an enriching teaching experience filled with passion and dedication. Let's inspire our students to embrace and love every aspect of this certification course journey!",
          "from": "admin",
          "time": DateTime.now().toIso8601String(),
        }
      }, SetOptions(merge: true));

      members.add(element.values.first);
    }

    for (var element in batch.students) {
      String regID =
          "${batch.name}STU${(batch.students.indexOf(element) + 1).toString().padLeft(3, '0')}";
      Map<String, dynamic> studentData = element.toMap();
      studentData.addEntries([
        MapEntry("id", regID),
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
      } else {
        sendInvitation();
      }

      members.add(element.email);
    }

    await FirebaseFirestore.instance
        .collection("forum")
        .doc(batch.name.trim())
        .set({
      "members": members,
      "details": {
        "name": batch.name,
        "image": batch.certificateData["image"],
      },
      "admin|${DateTime.now().toIso8601String()}": {
        "text":
            "A heartfelt welcome to all our students at Vectra Advantage Pro - where learning meets excellence, and success is a shared journey!",
        "from": "admin",
        "time": DateTime.now().toIso8601String()
      }
    }, SetOptions(merge: true));

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
