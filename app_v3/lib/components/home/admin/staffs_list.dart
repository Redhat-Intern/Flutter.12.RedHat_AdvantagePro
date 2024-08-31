import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart';
import '../../../providers/user_detail_provider.dart';
import '../../../utilities/static_data.dart';
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
  List<UserModel> staffsList = [];

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    UserModel userData = ref.watch(userDataProvider).key;

    Stream<QuerySnapshot<Map<String, dynamic>>> queryStream =
        userData.userRole == UserRole.superAdmin
            ? FirebaseFirestore.instance
                .collection("users")
                .where("userRole", whereIn: ["staff", "admin"]).snapshots()
            : FirebaseFirestore.instance
                .collection("users")
                .where("userRole", whereIn: ["staff"]).snapshots();

    double width = sizeData.width;
    double height = sizeData.height;

    return StreamBuilder(
        stream: queryStream,
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
              UserModel staffData = UserModel.fromJson(element.data());
              staffsList.add(staffData);
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
                    if (userData.userRole == UserRole.superAdmin)
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
                                      staff: staffsList[index],
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CustomNetworkImage(
                                    url: staffsList[index].imagePath,
                                    size: height * 0.07,
                                    radius: 8,
                                    rightMargin: width * .03,
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    left: -4,
                                    child: SizedBox(
                                      width: height * .085,
                                      child: CustomText(
                                        text: staffsList[index]
                                            .name
                                            .toUpperCase(),
                                        size: sizeData.tooSmall,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
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
