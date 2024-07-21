import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pages/details/batch_detail.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../../pages/show_all/batches.dart';
import '../../common/icon.dart';
import '../../common/text.dart';
import '../../common/waiting_widgets/recent_waiting.dart';
import 'recent_place_holder.dart';

class Recent extends ConsumerStatefulWidget {
  const Recent({super.key});

  @override
  ConsumerState<Recent> createState() => _RecentState();
}

class _RecentState extends ConsumerState<Recent> {
  final ScrollController _controller = ScrollController();
  bool needToLoad = true;
  List<Map<String, dynamic>> recentBatches = [];

  int firstIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("batches").snapshots(),
        builder: (context, snapshot) {
          if (needToLoad &&
              snapshot.connectionState == ConnectionState.waiting &&
              recentBatches.isEmpty) {
            needToLoad = false;
            return const RecentWaitingWidget();
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!.docs;

            recentBatches = [];
            for (QueryDocumentSnapshot<Map<String, dynamic>> i in docs) {
              Map<String, dynamic> data = i.data();
              int count = List.from(data["students"]).length;
              data.addAll({"count": count});
              recentBatches.add(data);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Recent",
                      size: sizeData.subHeader,
                      color: colorData.fontColor(.8),
                      weight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Batches(),
                          ),
                        );
                      },
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
                  padding: EdgeInsets.only(
                    top: height * 0.015,
                    bottom: height * 0.01,
                    left: width * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: colorData.secondaryColor(.4),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Container(
                                height: aspectRatio * 15,
                                width: aspectRatio * 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorData.primaryColor(1),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              CustomText(
                                text: recentBatches[firstIndex]["name"]
                                    .toString(),
                                size: sizeData.regular,
                                color: colorData.fontColor(.7),
                              ),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              CustomText(
                                text: "Student count:",
                                size: sizeData.small,
                                color: colorData.fontColor(.6),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              CustomText(
                                text: recentBatches[firstIndex]["count"]
                                    .toString(),
                                size: sizeData.regular,
                                color: colorData.fontColor(.8),
                                weight: FontWeight.bold,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.002,
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo is ScrollUpdateNotification) {
                              // Check the first visible item index
                              int firstVisibleItemIndex =
                                  (_controller.position.maxScrollExtent > 0
                                      ? ((_controller.position.pixels /
                                                  _controller.position
                                                      .maxScrollExtent) *
                                              (recentBatches.length - 1))
                                          .floor()
                                      : 0);
                              firstVisibleItemIndex = firstVisibleItemIndex >= 0
                                  ? firstVisibleItemIndex
                                  : 0;
                              setState(() {
                                firstIndex = firstVisibleItemIndex;
                              });
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _controller,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.01,
                            ),
                            itemCount: recentBatches.length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              bool isFirst = firstIndex == index;
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BatchDetail(
                                      batchData: recentBatches[index],
                                    ),
                                  ),
                                ),
                                child: NetworkImageRender(
                                  certificateID: recentBatches[index]
                                      ["certificateID"],
                                  radius: 8,
                                  size: height * .14,
                                  rightMargin: width * 0.02,
                                  border: isFirst
                                      ? Border.all(
                                          color: colorData.primaryColor(.6),
                                          width: 2,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const RecentPlaceHolder(
              header: "Recent",
              text: "No Batches have been crested till NOW!",
            );
          }
        });
  }
}
