import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../../pages/add_staff.dart';
import '../../../pages/details/staff_detail.dart';
import '../../../pages/show_all/staffs.dart';
import '../../common/icon.dart';
import '../../common/text.dart';
import 'staffs_list_place_holder.dart';

class StaffsList extends ConsumerWidget {
  const StaffsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

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
                  builder: (BuildContext context) => const Staffs(),
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
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStaff(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin:
                      EdgeInsets.only(right: width * 0.02, left: width * 0.01),
                  decoration: BoxDecoration(
                    color: colorData.secondaryColor(1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIcon(
                    size: aspectRatio * 60,
                    icon: Icons.add_rounded,
                    color: colorData.fontColor(.7),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: height * 0.075,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("staffs")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          List<Map<String, dynamic>> staffsList = [];
                          for (var element in snapshot.data!.docs) {
                            Map<String, dynamic> staffList = {
                              "email": element.id
                            };
                            element.data().entries.forEach((element) {
                              staffList.addAll({element.key: element.value});
                            });
                            staffsList.add(staffList);
                          }

                          return ListView.builder(
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
                                        phoneNumber: staffsList[index]
                                            ["phoneNo"],
                                        photoURL: staffsList[index]["photo"],
                                        experience: staffsList[index]
                                            ["experience"],
                                        certificatesURL: staffsList[index]
                                            ["certificates"],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: height * 0.075,
                                  margin: EdgeInsets.only(
                                    right: width * 0.04,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: colorData.secondaryColor(1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      staffsList[index]["photo"],
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Shimmer.fromColors(
                                            baseColor:
                                                colorData.backgroundColor(.1),
                                            highlightColor:
                                                colorData.secondaryColor(.1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: colorData
                                                    .secondaryColor(.5),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const StaffsListPlaceHolder();
                        }
                      } else {
                        return Center(
                          child: CustomText(
                            text: "No Staff Available",
                            size: sizeData.regular,
                            color: colorData.fontColor(.6),
                            weight: FontWeight.w600,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
