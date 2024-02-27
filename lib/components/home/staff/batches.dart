import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../../pages/show_all/batches.dart';
import '../../common/icon.dart';
import '../../common/text.dart';
import '../admin/recent_place_holder.dart';

class StaffBatches extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> batches;
  const StaffBatches({super.key, required this.batches});

  @override
  ConsumerState<StaffBatches> createState() => _StaffBatches();
}

class _StaffBatches extends ConsumerState<StaffBatches> {
  final ScrollController _controller = ScrollController();
  List<Map<String, dynamic>> recentBatches = [];

  int firstIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.batches.isNotEmpty) {
      for (var element in widget.batches) {
        Map<String, dynamic> data = element;
        FirebaseFirestore.instance
            .collection("certificates")
            .doc(element["certificateID"])
            .get()
            .then((value) {
          setState(() {
            data.addAll(value.data()!);
            recentBatches.add(data);
          });
        });
      }
    }
  }

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

    return recentBatches.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Batches",
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
                  top: height * 0.01,
                  bottom: height * 0.006,
                  left: width * 0.02,
                ),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: SizedBox(
                    height: height * 0.18,
                    child: ListView.builder(
                      controller: _controller,
                      padding: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                        top: height * 0.005,
                        // bottom: height * 0.005,
                      ),
                      itemCount: recentBatches.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        bool isLive = recentBatches[index]["isLive"];
                        // bool isLive = recentBatches[index]["completed"] ?? true;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: -width * 0.03,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: aspectRatio * 15,
                                        width: aspectRatio * 15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorData.primaryColor(1),
                                        ),
                                      ),
                                    ),
                                    CustomText(
                                      text: recentBatches[firstIndex]["id"]
                                          .toString(),
                                      size: sizeData.regular,
                                      color: colorData.fontColor(.7),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.02),
                                    padding: EdgeInsets.all(isLive ? 3 : 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: isLive
                                              ? colorData.primaryColor(.6)
                                              : Colors.transparent,
                                          width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        recentBatches[index]["image"],
                                        width: height * 0.12,
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
                                                width: height * .12,
                                                decoration: BoxDecoration(
                                                  color: colorData
                                                      .secondaryColor(.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: -height * 0.002,
                              left: 0,
                              right: 0,
                              child: CustomText(
                                text: recentBatches[firstIndex]["isLive"]
                                    ? "LIVE"
                                    : "COMPLETED",
                                size: sizeData.small,
                                color: recentBatches[firstIndex]["isLive"]
                                    ? Colors.green
                                    : Colors.red,
                                weight: FontWeight.bold,
                                align: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    )),
              )
            ],
          )
        : const RecentPlaceHolder(
            header: "Batches",
            text: "You are not assigned with any Batches till Now!");
  }
}
