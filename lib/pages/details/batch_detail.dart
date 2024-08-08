import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/network_image.dart';
import 'package:redhat_v1/components/common/shimmer_box.dart';
import 'package:redhat_v1/components/common/text_list.dart';
import 'package:redhat_v1/pages/show_all/batches.dart';

import '../../components/common/page_header.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/common/text.dart';

class BatchDetail extends ConsumerStatefulWidget {
  const BatchDetail({super.key, required this.batchData});
  final Map<String, dynamic> batchData;

  @override
  ConsumerState<BatchDetail> createState() => BatchDeatilState();
}

class BatchDeatilState extends ConsumerState<BatchDetail> {
  Map<String, dynamic> studentsData = {};
  Map<String, dynamic> staffsData = {};

  getStudentData() async {
    QuerySnapshot<Map<String, dynamic>> studentsQueryData =
        await FirebaseFirestore.instance.collection("students").get();

    QuerySnapshot<Map<String, dynamic>> staffsQueryData =
        await FirebaseFirestore.instance.collection("staffs").get();

    for (var element in studentsQueryData.docs) {
      if (Map.fromEntries(List.from(widget.batchData["students"])
              .map((e) => MapEntry(e.keys.first, e.values.first)))
          .values
          .contains(element.id)) {
        setState(() {
          studentsData.addAll({element.id: element.data()});
        });
      }
    }

    for (var element in staffsQueryData.docs) {
      if (List.from(widget.batchData["staffs"]).contains({element.id: element.data()["id"]})) {
        setState(() {
          staffsData.addAll({element.id: element.data()});
        });
      }
    }
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

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;
    bool status = !(widget.batchData["completed"] == true);

    print(staffsData);

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
                      certificateID: widget.batchData["certificateID"],
                      size: width * .25,
                      radius: 10,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BatchDetailTile(
                        title: "Certificate ID",
                        value: widget.batchData["certificateID"],
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

  final Map<String, dynamic> staffsData;

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

    List<MapEntry<String, dynamic>> staffsData =
        widget.staffsData.entries.toList();
    List<String> staffNames =
        staffsData.map((e) => e.value["name"].toString()).toList();

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
                              url: staffsData[currentIndex].value["photo"],
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
                                  text: staffsData[currentIndex]
                                      .value["id"]
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

  final Map<String, dynamic> studentsData;

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

    List<MapEntry<String, dynamic>> studentsData =
        widget.studentsData.entries.toList();
    List<String> studetnsName =
        studentsData.map((e) => e.value["name"].toString()).toList();

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
                              url: studentsData[currentIndex].value["photo"],
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
                                  text: studentsData[currentIndex]
                                      .value["id"][studentsData[currentIndex]
                                          .value["currentBatch"]
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
