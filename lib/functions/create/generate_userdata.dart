import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';

Future<Map<String, dynamic>?> generateUserData({
  required WidgetRef ref,
  required BuildContext context,
  required String id,
}) async {
  UserRole role = ref.watch(userRoleProvider)!;
  String colName = role == UserRole.staff ? "staffRequest" : "studentRequest";
  QuerySnapshot<Map<String, dynamic>> queryData = await FirebaseFirestore
      .instance
      .collection(colName)
      .where("id", isEqualTo: id.toUpperCase())
      .get();
  if (queryData.docs.isNotEmpty) {
    Map<String, dynamic> userData =
        Map.fromEntries(queryData.docs.first.data().entries);
    userData.addAll({"email": queryData.docs.first.id});
    return userData;
  } else {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: CustomText(
          text:
              "The Provided ${role.name.toString().toUpperCase()} ID is not available!",
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  }
  return null;
}
