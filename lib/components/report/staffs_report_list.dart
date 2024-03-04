import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../pages/details/staff_batch_detail.dart';
import '../common/text.dart';
import 'staff_image_button.dart';

class StaffsReportList extends ConsumerStatefulWidget {
  const StaffsReportList({
    super.key,
    required this.staffsListData,
    required this.adminStaffData,
  });

  final List<Map<String, dynamic>> staffsListData;
  final Map<String, dynamic> adminStaffData;

  @override
  ConsumerState<StaffsReportList> createState() => _StaffsReportList();
}

class _StaffsReportList extends ConsumerState<StaffsReportList> {
  Map<String, dynamic> adminStaffData = {};
  List<Map<String, dynamic>> allStaffData = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("staffs")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      setState(() {
        adminStaffData = value.docs
            .firstWhere(
                (element) => element.id == widget.adminStaffData.values.first)
            .data();

        for (var element in value.docs) {
          if (widget.staffsListData
              .contains({element.data()["id"]: element.id})) {
            allStaffData.add(element.data());
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
    double aspectRatio = sizeData.aspectRatio;

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
            adminStaffData.isNotEmpty
                ? StaffImageButton(
                    todo: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StaffBatchDetail(data: adminStaffData))),
                    imageUrl: adminStaffData["photo"],
                  )
                : const SizedBox(),
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
                              imageUrl: allStaffData[index]["photo"]);
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
