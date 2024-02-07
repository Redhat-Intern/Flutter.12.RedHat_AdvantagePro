import 'package:cloud_firestore/cloud_firestore.dart';

Future updateBatchList(
    {required String batch, required String certificateName}) async {
  DocumentSnapshot<Map<String, dynamic>> certificateData =
      await FirebaseFirestore.instance
          .collection("certificates")
          .doc(certificateName)
          .get();
  List<dynamic> batches = certificateData["batches"];
  batches.add(batch);
  
  await FirebaseFirestore.instance
      .collection("certificates")
      .doc(certificateName)
      .update({"batches": batches});
}
