import 'package:cloud_firestore/cloud_firestore.dart';

void acceptInvitation({
  required String email,
  required String batchID,
}) {
  FirebaseFirestore.instance
      .collection("notifications")
      .doc("invitations")
      .set({
    email: {batchID: FieldValue.delete()}
  }, SetOptions(merge: true));

  FirebaseFirestore.instance.collection("staffs").doc(email).set({
    "batches": FieldValue.arrayUnion([batchID])
  }, SetOptions(merge: true));
}
