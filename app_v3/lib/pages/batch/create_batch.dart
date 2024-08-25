import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/icon.dart';
import '../../components/common/network_image.dart';
import '../../components/common/page_header.dart';
import '../../components/common/text.dart';
import '../../model/user.dart';
import '../../providers/create_batch_provider.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'create_new_batch.dart';
import 'create_saved_batch.dart';

class CreateBatch extends ConsumerStatefulWidget {
  const CreateBatch({super.key});

  @override
  ConsumerState<CreateBatch> createState() => _CreateBatchState();
}

class _CreateBatchState extends ConsumerState<CreateBatch> {
  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtr.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = ref.watch(userDataProvider).key;
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
          child: Column(children: [
            const PageHeader(tittle: "Create Batch", isMenuButton: false),
            SizedBox(
              height: height * 0.02,
            ),

            if (userData.userRole == UserRole.superAdmin)
              //   Add course
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateNewBatch())),
                child: Container(
                  margin: EdgeInsets.only(bottom: height * 0.03),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.01,
                    horizontal: width * 0.1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorData.primaryColor(.6),
                        colorData.primaryColor(1),
                      ],
                    ),
                  ),
                  child: CustomText(
                    text: "Create/Save New Batch",
                    size: sizeData.medium,
                    color: colorData.secondaryColor(1),
                    weight: FontWeight.w800,
                  ),
                ),
              ),

            // Course List

            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Saved Batches",
                size: sizeData.subHeader,
                color: colorData.fontColor(.8),
                weight: FontWeight.w600,
              ),
            ),

            Container(
              height: height * 0.045,
              margin: EdgeInsets.only(top: height * .015, bottom: height * .02),
              padding: EdgeInsets.only(
                top: height * 0.008,
                bottom: height * 0.008,
                left: width * 0.04,
                right: width * 0.01,
              ),
              decoration: BoxDecoration(
                color: colorData.secondaryColor(.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchCtr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: aspectRatio * 33,
                    color: colorData.fontColor(.8),
                    height: .75),
                scrollPadding: EdgeInsets.zero,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    bottom: height * 0.02,
                  ),
                  hintText: "Search for saved batches",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeData.medium,
                    color: colorData.fontColor(.5),
                  ),
                  border: InputBorder.none,
                  suffixIcon: CustomIcon(
                    icon: Icons.search_rounded,
                    color: colorData.fontColor(.6),
                    size: aspectRatio * 50,
                  ),
                ),
              ),
            ),

            // List of Courses

            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("savedBatches")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> batchDataList = snapshot
                          .data!.docs
                          .map((value) => value.data())
                          .toList();

                      if (searchCtr.text.isNotEmpty) {
                        batchDataList = batchDataList
                            .where((data) => data["name"]
                                .toString()
                                .toLowerCase()
                                .startsWith(
                                    searchCtr.text.trim().toLowerCase()))
                            .toList();
                      }

                      return batchDataList.isEmpty
                          ? Column(
                              children: [
                                SizedBox(height: height * 0.04),
                                Image.asset(
                                  "assets/icons/PNF1.png",
                                  width: width * .7,
                                ),
                                SizedBox(height: height * 0.04),
                                const CustomText(text: "NO BATCHES FOUND"),
                              ],
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              itemCount: batchDataList.length,
                              itemBuilder: (context, index) {
                                //
                                //
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(createBatchProvider.notifier)
                                        .setBatchName(
                                            batchDataList[index]["name"]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateSavedBatch(
                                          courseID: batchDataList[index]
                                              ["courseID"],
                                          name: batchDataList[index]["name"],
                                          selectDates: List.from(
                                            batchDataList[index]["dates"],
                                          ),
                                          staffID: List.from(
                                                  batchDataList[index]
                                                      ["staffs"])
                                              .map((element) =>
                                                  Map.from(element)
                                                      .keys
                                                      .first
                                                      .toString())
                                              .toList(),
                                        ),
                                      ),
                                    ).then((_) {
                                      ref
                                          .read(createBatchProvider.notifier)
                                          .clearData();
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: height * 0.02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: width * 0.015,
                                        horizontal: width * 0.015),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: colorData.secondaryColor(.2),
                                          width: 2,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                        ),
                                        color: colorData.secondaryColor(.1)),
                                    child: Row(
                                      children: [
                                        ImageLoader(
                                            courseID: batchDataList[index]
                                                ["courseID"]),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Name: ",
                                                    style: TextStyle(
                                                      fontSize: sizeData.small,
                                                      color: colorData
                                                          .fontColor(.6),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: batchDataList[index]
                                                        ["name"],
                                                    style: TextStyle(
                                                      fontSize: sizeData.medium,
                                                      color: colorData
                                                          .fontColor(.9),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height * 0.008),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Course ID: ",
                                                    style: TextStyle(
                                                      fontSize: sizeData.small,
                                                      color: colorData
                                                          .fontColor(.6),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: batchDataList[index]
                                                        ["courseID"],
                                                    style: TextStyle(
                                                      fontSize: sizeData.medium,
                                                      color: colorData
                                                          .fontColor(.9),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height * 0.008),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Course Days: ",
                                                    style: TextStyle(
                                                      fontSize: sizeData.small,
                                                      color: colorData
                                                          .fontColor(.6),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: List.from(
                                                            batchDataList[index]
                                                                ["dates"])
                                                        .length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: sizeData.medium,
                                                      color: colorData
                                                          .fontColor(.9),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height * 0.008),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: "Dates: ",
                                                  size: sizeData.small,
                                                  color:
                                                      colorData.fontColor(.6),
                                                  weight: FontWeight.w600,
                                                ),
                                                Container(
                                                  height: height * .032,
                                                  width: width * .45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: colorData
                                                          .backgroundColor(1)),
                                                  child: ListView.builder(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.01,
                                                            vertical:
                                                                height * 0.004),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: List.from(
                                                            batchDataList[index]
                                                                ["dates"])
                                                        .length,
                                                    itemBuilder: (context, i) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 1,
                                                                horizontal:
                                                                    width *
                                                                        0.02),
                                                        margin: EdgeInsets.only(
                                                            right:
                                                                width * 0.015),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorData
                                                              .secondaryColor(
                                                                  .2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                            color: colorData
                                                                .secondaryColor(
                                                                    .6),
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: CustomText(
                                                          text: List.from(
                                                                  batchDataList[
                                                                          index]
                                                                      [
                                                                      "dates"])[i]
                                                              .toString(),
                                                          size: sizeData.small,
                                                          color: colorData
                                                              .fontColor(
                                                            .8,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}

class ImageLoader extends ConsumerStatefulWidget {
  const ImageLoader({super.key, required this.courseID});
  final String courseID;

  @override
  ConsumerState<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends ConsumerState<ImageLoader> {
  String? imagePath;

  fetchImagePath() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("courses")
        .doc(widget.courseID)
        .get();
    setState(() {
      imagePath = data.data()!["image"];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchImagePath();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;

    return CustomNetworkImage(
      size: height * .12,
      radius: 8,
      url: imagePath,
      rightMargin: sizeData.width * 0.03,
    );
  }
}
