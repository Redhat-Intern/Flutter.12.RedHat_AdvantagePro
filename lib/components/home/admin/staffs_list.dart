import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../../pages/details/staff_detail.dart';
import '../../../pages/show_all/staffs.dart';
import '../../common/icon.dart';
import '../../common/network_image.dart';
import '../../common/text.dart';
import '../../common/waiting_widgets/staffs_list_waiting.dart';
import 'staff_add_button.dart';
import 'staffs_list_place_holder.dart';

class StaffsList extends ConsumerStatefulWidget {
  const StaffsList({super.key});

  @override
  ConsumerState<StaffsList> createState() => StaffsListState();
}

class StaffsListState extends ConsumerState<StaffsList> {
  bool needToLoad = true;
  List<Map<String, dynamic>> staffsList = [];

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("userRole", isEqualTo: "staff")
            .snapshots(),
        builder: (context, snapshot) {
          if (needToLoad &&
              snapshot.connectionState == ConnectionState.waiting &&
              staffsList.isEmpty) {
            needToLoad = false;
            return const StaffsListWaiting();
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            staffsList = [];
            for (var element in snapshot.data!.docs) {
              Map<String, dynamic> staffList = {"email": element.id};
              element.data().entries.forEach((element) {
                staffList.addAll({element.key: element.value});
              });
              staffsList.add(staffList);
            }

            return Column(
              children: [
                // Header Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Staffs",
                      size: sizeData.subHeader,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const AllStaffs(),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "All",
                            size: sizeData.medium,
                            color: colorData.fontColor(.8),
                          ),
                          CustomIcon(
                            size: sizeData.subHeader,
                            icon: Icons.arrow_forward_ios_rounded,
                            color: colorData.fontColor(.8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.0125,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const StaffAddButton(),
                    Expanded(
                      child: SizedBox(
                        height: height * 0.075,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.02),
                          itemCount: staffsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaffDetail(
                                      name: staffsList[index]["name"],
                                      email: staffsList[index]["email"],
                                      phoneNumber: staffsList[index]["phoneNo"],
                                      photoURL: staffsList[index]["photo"],
                                      experience: staffsList[index]
                                          ["experience"],
                                      certificatesURL: staffsList[index]
                                          ["certificates"],
                                    ),
                                  ),
                                );
                              },
                              child: CustomNetworkImage(
                                url: staffsList[index]["photo"],
                                size: height * 0.075,
                                radius: 8,
                                rightMargin: width * .03,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const StaffsListPlaceHolder();
          }
        });
  }
}
