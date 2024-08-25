import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../model/user.dart';
import '../../pages/details/staff_batch_detail.dart';
import '../common/text.dart';
import 'staff_image_button.dart';

class StaffsReportList extends ConsumerStatefulWidget {
  const StaffsReportList({
    super.key,
    required this.staffsListData,
  });

  final List<MapEntry> staffsListData;

  @override
  ConsumerState<StaffsReportList> createState() => _StaffsReportList();
}

class _StaffsReportList extends ConsumerState<StaffsReportList> {
  UserModel? adminStaffData;
  List<UserModel> allStaffData = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      setState(() {
        adminStaffData = UserModel.fromJson(value.docs
            .firstWhere((element) => element.data()["userRole"] == "admin")
            .data());

        for (var element in value.docs) {
          if (widget.staffsListData
              .map((e) => e.key)
              .toList()
              .contains(element.data()["id"].toString().toUpperCase())) {
            allStaffData.add(UserModel.fromJson(element.data()));
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Text
        CustomText(
          text: "Staffs",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w700,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (adminStaffData != null)
              StaffImageButton(
                todo: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StaffBatchDetail(data: adminStaffData!))),
                imageUrl: adminStaffData!.imagePath,
                name: adminStaffData!.name,
                isAdmin: true,
              ),
            Expanded(
              child: Container(
                height: height * 0.09,
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  top: height * 0.01,
                  bottom: height * 0.01,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: colorData.secondaryColor(.5),
                ),
                alignment: Alignment.center,
                child: allStaffData.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        itemCount: allStaffData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return StaffImageButton(
                            todo: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffBatchDetail(
                                        data: allStaffData[index]))),
                            imageUrl: allStaffData[index].imagePath,
                            name: allStaffData[index].name,
                          );
                        },
                      )
                    : const CustomText(
                        text: "No staffs have been assigned yet!"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
