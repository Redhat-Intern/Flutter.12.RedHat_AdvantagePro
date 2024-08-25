import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/network_image.dart';
import '../../components/common/page_header.dart';
import '../../components/common/shimmer_box.dart';
import '../../components/common/text_list.dart';
import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/common/text.dart';
import '../show_all/batches.dart';

class BatchDetail extends ConsumerStatefulWidget {
  const BatchDetail({super.key, required this.batchData});
  final Map<String, dynamic> batchData;

  @override
  ConsumerState<BatchDetail> createState() => BatchDeatilState();
}

class BatchDeatilState extends ConsumerState<BatchDetail> {
  List<UserModel> studentsData = [];
  List<UserModel> staffsData = [];

  getStudentData() async {
    QuerySnapshot<Map<String, dynamic>> userDataQuery =
        await FirebaseFirestore.instance.collection("users").get();

    for (var element in userDataQuery.docs) {
      UserModel userData = UserModel.fromJson(element.data());
      if (List.from(widget.batchData["staffs"])
          .where((data) =>
              Map<String, String>.from(data).values.first.toLowerCase() ==
              userData.email.toLowerCase())
          .isNotEmpty) {
        setState(() {
          staffsData.add(userData);
        });
      } else if (List.from(widget.batchData["students"])
          .where((data) =>
              Map<String, String>.from(data).values.first.toLowerCase() ==
              userData.email.toLowerCase())
          .isNotEmpty) {
        setState(() {
          studentsData.add(userData);
        });
      }
    }
  }

  void deleteBatch() {
    FirebaseFirestore.instance
        .collection("batches")
        .doc(widget.batchData["name"])
        .delete()
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("BATCH: ${widget.batchData["name"]} is deleted"),
          ),
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    getStudentData();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    UserModel userModel = ref.watch(userDataProvider).key;

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    bool status = !(widget.batchData["completed"] == true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                tittle: widget.batchData["name"],
                isMenuButton: false,
                secondaryWidget: userModel.userRole == UserRole.superAdmin
                    ? Center(
                        child: GestureDetector(
                          onTap: () => deleteBatch(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.008,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red,
                            ),
                            child: CustomText(
                              text: "DELETE",
                              size: sizeData.regular,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(aspectRatio * 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorData.primaryColor(1),
                    ),
                    child: NetworkImageRender(
                      courseID: widget.batchData["courseID"],
                      size: width * .25,
                      radius: 10,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BatchDetailTile(
                        title: "Course ID",
                        value: widget.batchData["courseID"],
                      ),
                      BatchDetailTile(
                        title: "Created Date",
                        value: widget.batchData["time"],
                      ),
                      BatchDetailTile(
                        title: "Status",
                        value: status ? "LIVE" : "COMPLETED",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              staffsData.isEmpty
                  ? const BatchDetailTileShimmer()
                  : BatchStaffDetail(staffsData: staffsData),
              SizedBox(height: height * 0.02),
              studentsData.isEmpty
                  ? const BatchDetailTileShimmer()
                  : BatchStudentDetail(studentsData: studentsData),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class BatchDetailTileShimmer extends ConsumerWidget {
  const BatchDetailTileShimmer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: sizeData.superHeader, width: width * .25),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorData.secondaryColor(.15),
            ),
            child: Row(
              children: [
                ShimmerBox(
                  height: height * 0.03,
                  width: width * .2,
                ),
                SizedBox(width: width * 0.04),
                Opacity(
                  opacity: .5,
                  child: ShimmerBox(
                    height: height * 0.03,
                    width: width * .2,
                  ),
                ),
                SizedBox(width: width * 0.04),
                Opacity(
                  opacity: .3,
                  child: ShimmerBox(
                    height: height * 0.03,
                    width: width * .2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorData.secondaryColor(.3),
              ),
              child: Row(children: [
                Column(
                  children: [
                    ShimmerBox(
                      height: height * .125,
                      width: height * .125,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    ShimmerBox(height: sizeData.header, width: width * .25)
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class BatchStaffDetail extends ConsumerStatefulWidget {
  const BatchStaffDetail({
    super.key,
    required this.staffsData,
  });

  final List<UserModel> staffsData;

  @override
  ConsumerState<BatchStaffDetail> createState() => _BatchStaffDetailState();
}

class _BatchStaffDetailState extends ConsumerState<BatchStaffDetail> {
  int currentIndex = 0;

  setIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    List<String> staffNames =
        widget.staffsData.map((e) => e.name.toString()).toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.01),
            child: CustomText(
              text: "STAFFS",
              size: sizeData.medium,
              weight: FontWeight.w800,
              color: colorData.fontColor(.7),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          CustomListText(
            fromHeight: height * 0.05,
            verticalPadding: height * 0.001,
            horizontalPadding: width * 0.03,
            fontSize: sizeData.medium,
            highlightColor: colorData.primaryColor(1),
            index: currentIndex,
            todo: setIndex,
            data: staffNames,
            getChild: (index) => staffNames[index],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorData.secondaryColor(.4),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomNetworkImage(
                              size: height * 0.125,
                              padding: aspectRatio * 6,
                              radius: 8,
                              url: widget.staffsData[currentIndex].imagePath,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            RatingStars(
                              animationDuration: Durations.long4,
                              valueLabelVisibility: false,
                              value: 4,
                              starColor: colorData.primaryColor(1),
                              starOffColor: colorData.fontColor(.1),
                              starBuilder: (index, color) {
                                return Icon(
                                  Icons.star_rounded,
                                  color: color,
                                  size: aspectRatio * 50,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "Staff ID:",
                                  color: colorData.fontColor(.6),
                                  size: sizeData.small,
                                  weight: FontWeight.w700,
                                ),
                                SizedBox(
                                  width: width * .02,
                                ),
                                CustomText(
                                  text: widget.staffsData[currentIndex].staffId
                                      .toString()
                                      .toUpperCase(),
                                  weight: FontWeight.w800,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomListText(
                        fromHeight: height * 0.0425,
                        verticalPadding: 0,
                        horizontalPadding: width * 0.02,
                        data: const [
                          "Very good teaching",
                          "Excellent explaination",
                          "Motivating",
                          "Responds anytime"
                        ],
                        getChild: (index) => [
                              "Very good teaching",
                              "Excellent explaination",
                              "Motivating",
                              "Responds anytime"
                            ][index]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BatchStudentDetail extends ConsumerStatefulWidget {
  const BatchStudentDetail({super.key, required this.studentsData});

  final List<UserModel> studentsData;

  @override
  ConsumerState<BatchStudentDetail> createState() => _BatchStudentDetailState();
}

class _BatchStudentDetailState extends ConsumerState<BatchStudentDetail> {
  int currentIndex = 0;

  setIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    List<String> studetnsName =
        widget.studentsData.map((e) => e.name.toString()).toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.01),
            child: CustomText(
              text: "STUDENTS",
              size: sizeData.medium,
              weight: FontWeight.w800,
              color: colorData.fontColor(.7),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          CustomListText(
            fromHeight: height * 0.05,
            verticalPadding: height * 0.001,
            horizontalPadding: width * 0.03,
            fontSize: sizeData.medium,
            highlightColor: colorData.primaryColor(1),
            index: currentIndex,
            todo: setIndex,
            data: studetnsName,
            getChild: (index) => studetnsName[index],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorData.secondaryColor(.4),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomNetworkImage(
                              size: height * 0.125,
                              padding: aspectRatio * 6,
                              radius: 8,
                              url: widget.studentsData[currentIndex].imagePath,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "Student ID:",
                                  color: colorData.fontColor(.6),
                                  size: sizeData.small,
                                  weight: FontWeight.w700,
                                ),
                                SizedBox(
                                  width: width * .02,
                                ),
                                CustomText(
                                  text: widget
                                      .studentsData[currentIndex]
                                      .studentId![widget
                                          .studentsData[currentIndex]
                                          .currentBatch!
                                          .keys
                                          .first]
                                      .toString()
                                      .toUpperCase(),
                                  weight: FontWeight.w800,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BatchDetailTile extends ConsumerWidget {
  const BatchDetailTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.008),
      child: Row(
        children: [
          CustomText(
            text: "$title:",
            color: colorData.fontColor(.6),
            weight: FontWeight.w700,
          ),
          SizedBox(
            width: width * .02,
          ),
          CustomText(
            text: value,
            size: sizeData.subHeader,
            color: title == "Status"
                ? value == "LIVE"
                    ? Colors.green.shade700
                    : Colors.red
                : colorData.fontColor(.9),
            weight: title == "Status" ? FontWeight.w900 : FontWeight.w800,
          ),
        ],
      ),
    );
  }
}
