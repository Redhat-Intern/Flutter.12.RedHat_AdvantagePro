import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/common/text.dart';

Future<Map<String, dynamic>?> generateUserData({
  required BuildContext context,
  required String id,
}) async {
  QuerySnapshot<Map<String, dynamic>> queryData = await FirebaseFirestore
      .instance
      .collection("requests")
      .where("id", isEqualTo: id.toUpperCase())
      .get();
  if (queryData.docs.isNotEmpty) {
    Map<String, dynamic> userData =
        Map.fromEntries(queryData.docs.first.data().entries);
    return userData;
  } else {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: const CustomText(
          text:
              "The Provided ID is not available!",
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  }
  return null;
}
