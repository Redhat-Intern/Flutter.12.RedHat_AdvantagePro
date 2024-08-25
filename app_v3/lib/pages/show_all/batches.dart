import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/loader_ball.dart';
import '../../components/common/network_image.dart';
import '../../components/common/page_header.dart';
import '../../components/common/text.dart';
import '../../components/common/waiting_widgets/all_batches_tile_waiting.dart';
import '../../components/show_all/batch/list_tile.dart';
import '../../components/show_all/batch/text_tile.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../details/batch_detail.dart';

class Batches extends ConsumerWidget {
  const Batches({super.key});

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
                tittle: "all batches",
                isMenuButton: false,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("batches")
                        .snapshots(),
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
                      List<Map<String, dynamic>> batchDataList =
                          snapshot.data!.docs.map((e) => e.data()).toList();

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01,
                          vertical: height * 0.01,
                        ),
                        itemCount: batchDataList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> batchData = batchDataList[index];
                          bool isLive = batchData["completed"] == null ||
                              batchData["completed"] == false;
                          int studentsListLength =
                              List.from(batchData["students"]).length;
                          List<String> dates = List.from(batchData["dates"]);

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BatchDetail(
                                      batchData: batchData,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (isLive)
                                                  Container(
                                                    height: aspectRatio * 14,
                                                    width: aspectRatio * 14,
                                                    margin: EdgeInsets.only(
                                                        right: width * 0.01),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: colorData
                                                          .primaryColor(1),
                                                    ),
                                                  ),
                                                CustomText(
                                                  text: batchData["name"],
                                                  weight: FontWeight.w800,
                                                  color:
                                                      colorData.fontColor(.7),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.006,
                                            ),
                                            NetworkImageRender(
                                              courseID:
                                                  batchData["courseID"],
                                              size: aspectRatio * 180,
                                              radius: 8,
                                              border: Border.all(
                                                color:
                                                    colorData.primaryColor(1),
                                                width: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BatchTileText(
                                              header: "Course:",
                                              value: batchData["courseID"],
                                            ),
                                            BatchTileText(
                                              header: "Created Time:",
                                              value: batchData["time"],
                                            ),
                                            BatchTileText(
                                              header: "Students Count:",
                                              value:
                                                  studentsListLength.toString(),
                                            ),
                                            BatchList(data: dates),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: height * 0.015,
                                right: width * 0.02,
                                child: CustomText(
                                  text: isLive ? "LIVE" : "COMPLETED",
                                  size: isLive
                                      ? sizeData.small
                                      : sizeData.verySmall,
                                  color: isLive
                                      ? colorData.primaryColor(1)
                                      : colorData.fontColor(.6),
                                  weight: FontWeight.w800,
                                ),
                              ),
                              index == batchDataList.length - 1
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

class NetworkImageRender extends StatefulWidget {
  const NetworkImageRender(
      {super.key,
      required this.courseID,
      required this.size,
      required this.radius,
      this.border,
      this.rightMargin});
  final String courseID;
  final double size;
  final double radius;
  final Border? border;
  final double? rightMargin;

  @override
  State<NetworkImageRender> createState() => _NetworkImageRenderState();
}

class _NetworkImageRenderState extends State<NetworkImageRender> {
  String? imageURL;

  fetchImageURL() {
    FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseID)
        .get()
        .then(
      (snapshot) {
        if (snapshot.data() != null) {
          setState(() {
            imageURL = snapshot.data()!["image"];
          });
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant NetworkImageRender oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseID != widget.courseID) {
      fetchImageURL();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      url: imageURL,
      size: widget.size,
      radius: widget.radius,
      border: widget.border,
      rightMargin: widget.rightMargin,
    );
  }
}
