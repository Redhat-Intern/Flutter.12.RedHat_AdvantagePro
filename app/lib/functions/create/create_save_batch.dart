import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:redhat_v1/providers/user_detail_provider.dart';

import 'send_email.dart';
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
        .set(batchData);

    await FirebaseFirestore.instance
        .collection("courses")
        .doc(batch.courseData["name"].toString().toUpperCase())
        .collection("instances")
        .doc(batch.name.toUpperCase())
        .set(batch.courseData);

    await FirebaseFirestore.instance
        .collection("savedBatches")
        .doc(batch.name.toUpperCase())
        .delete();

    List<String> members = ['admin'];
    QuerySnapshot<Map<String, dynamic>> userCollectionData =
        await FirebaseFirestore.instance.collection("users").get();
    Map<String, dynamic> adminData = userCollectionData.docs
        .firstWhere((data) => data.data()["userRole"] == "superAdmin")
        .data();

    for (var element in batch.staffs) {
      // String role = (isAdmin ? "admin" : "staff").toUpperCase();
      // await FirebaseFirestore.instance
      //     .collection("notifications")
      //     .doc("invitations")
      //     .set({
      //   element.email: {
      //     batch.name: {
      //       'message': 'You have been invited to join this batch as $role',
      //     }
      //   }
      // }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("users")
          .doc(element.email.toString().trim())
          .set({
        "batches": FieldValue.arrayUnion([batch.name.toUpperCase()])
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("forum")
          .doc("${element.email.toString().trim()}|admin")
          .set({
        "members": {
          "admin": {
            "name": adminData["name"],
            "imagePath": adminData["imagePath"],
            "userRole": "superAdmin",
          },
          element.email.toString().trim(): {
            "name": element.name,
            "imagePath": element.imagePath,
            "userRole": "staff",
          }
        },
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

      members.add(element.email);
    }

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

      QuerySnapshot<Map<String, dynamic>> studentList = await FirebaseFirestore
          .instance
          .collection("students")
          .where("email", isEqualTo: element.email)
          .get();

      // Future sendInvitation() async => await FirebaseFirestore.instance
      //         .collection("notifications")
      //         .doc("invitations")
      //         .set({
      //       element.email: {
      //         batch.name: {
      //           'message':
      //               'Welcome to the cretification course of ${batch.courseData["name"]}',
      //           'id': regID,
      //         }
      //       }
      //     }, SetOptions(merge: true));

      if (studentList.docs.isEmpty) {
        await sendStudentEmail(
          receiverEmail: element.email,
          name: element.name,
          batchID: batch.name.toUpperCase(),
          registrationNo: element.registrationID.toUpperCase(),
        );
      } else {
        // sendInvitation();
      }

      members.add(element.email);
    }

    Map<String, dynamic> membersData = {};

    for (var data in userCollectionData.docs) {
      if (data.data()["userRole"] == "superAdmin") {
        membersData["admin"] = {
          "name": data.data()["name"],
          "imagePath": data.data()["imagePath"],
          "userRole": "superAdmin",
        };
      } else if (members.contains(data.id) ||
          data.data()["userRole"] == "admin") {
        membersData[data.id] = {
          "name": data.data()["name"],
          "imagePath": data.data()["imagePath"],
          "userRole": data.data()["userRole"],
        };
      }
    }

    await FirebaseFirestore.instance
        .collection("forum")
        .doc(batch.name.trim().toUpperCase())
        .set({
      "members": membersData,
      "details": {
        "name": batch.name,
        "image": batch.courseData["image"],
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
