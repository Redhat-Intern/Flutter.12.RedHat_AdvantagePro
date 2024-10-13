import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/loader_ball.dart';
import '../../components/common/network_image.dart';
import '../../components/common/page_header.dart';
import '../../components/common/text.dart';
import '../../components/common/waiting_widgets/all_batches_tile_waiting.dart';
import '../../components/show_all/batch/text_tile.dart';
import '../../model/user.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../details/staff_detail.dart';

class AllStaffs extends ConsumerWidget {
  const AllStaffs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              const PageHeader(
                tittle: "all Staffs",
                isMenuButton: false,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("userRole",
                            whereIn: ["staff", "admin"]).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.01,
                            vertical: height * 0.01,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) => Opacity(
                              opacity: 1.0 - (index * .2),
                              child: const AllBatchesTileWaitingWidget()),
                        );
                      }
                      List<UserModel> staffDataList = snapshot.data!.docs
                          .map((e) => UserModel.fromJson(e.data()))
                          .toList();

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01,
                          vertical: height * 0.01,
                        ),
                        itemCount: staffDataList.length,
                        itemBuilder: (context, index) {
                          UserModel staffData = staffDataList[index];
                          // Map<String, dynamic> certifications =
                          //     staffData.courses!;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaffDetail(
                                      staff: staffData,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: height * 0.015,
                                    top: height * 0.01,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: colorData.secondaryColor(.15),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              text: staffData.staffId!
                                                  .toUpperCase(),
                                              weight: FontWeight.w800,
                                              color: colorData.fontColor(.7),
                                            ),
                                            SizedBox(
                                              height: height * 0.006,
                                            ),
                                            CustomNetworkImage(
                                              url: staffData.imagePath,
                                              size: aspectRatio * 200,
                                              radius: 8,
                                              border: Border.all(
                                                  color: colorData.primaryColor(
                                                      staffData.userRole ==
                                                              UserRole.admin
                                                          ? 1
                                                          : .4),
                                                  width: staffData.userRole ==
                                                          UserRole.admin
                                                      ? 3
                                                      : 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BatchTileText(
                                              header: "ID:",
                                              value: staffData.staffId!,
                                            ),
                                            BatchTileText(
                                              header: "Name:",
                                              value: staffData.name,
                                            ),
                                            BatchTileText(
                                              header: "Email:",
                                              value: staffData.email,
                                            ),
                                            BatchTileText(
                                              header: "Phone NO:",
                                              value: staffData.phoneNumber
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              index == staffDataList.length - 1
                                  ? Positioned(
                                      bottom: -height * 0.02,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          3,
                                          (index) => const LoaderBalls(),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
