import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../firebase_auth.dart';

Future createUser({
  required WidgetRef ref,
  required String email,
  required String password,
  required Map<String, dynamic> generatedData,
  required BuildContext context,
}) async {
  UserRole role = ref.watch(userRoleProvider)!;
  AuthFB()
      .createUserWithEmailAndPassword(
    email: email,
    password: password,
    role: role,
  )
      .then((value) {
    if (role == UserRole.student) {
      Map<String, dynamic> studentData = {
        "email": generatedData["email"],
        "name": generatedData["name"],
        "password":password,
        "phoneNo": generatedData["phoneNo"],
        "occupation": generatedData["occupation"],
        "occDetail": generatedData["occDetail"],
        "id": {generatedData["batchName"]: generatedData["id"]},
        "batches": {generatedData["batchName"]: generatedData["certificateID"]},
        "currentBatch": {
          generatedData["batchName"]: generatedData["certificateID"]
        },
      };
      FirebaseFirestore.instance
          .collection('${role.name}s')
          .doc(email)
          .set(studentData);

      FirebaseFirestore.instance
          .collection("studentRequest")
          .doc(email)
          .delete();
    } else {
      FirebaseFirestore.instance
          .collection('${role.name}s')
          .doc(email)
          .set(generatedData);
      FirebaseFirestore.instance.collection("staffRequest").doc(email).delete();
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }).catchError((error) {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: CustomText(
          text: error.message.toString(),
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  });
}
