import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/home/admin/recent_place_holder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../../pages/show_all/batches.dart';
import '../../common/icon.dart';
import '../../common/text.dart';

class Recent extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> recentBatches;
  const Recent({super.key, required this.recentBatches});

  @override
  ConsumerState<Recent> createState() => _RecentState();
}

class _RecentState extends ConsumerState<Recent> {
  final ScrollController _controller = ScrollController();
  List<Map<String, dynamic>> recentBatches = [];

  int firstIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.recentBatches.isNotEmpty) {
      for (var element in widget.recentBatches) {
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
    super.dispose();
    _controller.dispose();
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
                              text: recentBatches[firstIndex]["id"].toString(),
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
                              text:
                                  recentBatches[firstIndex]["count"].toString(),
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
                              return Container(
                                margin: EdgeInsets.only(right: width * 0.02),
                                padding: EdgeInsets.all(isFirst ? 3 : 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: isFirst
                                          ? colorData.primaryColor(.6)
                                          : Colors.transparent,
                                      width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    recentBatches[index]["image"],
                                    width: height * 0.13,
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
                                            width: width * 0.25,
                                            decoration: BoxDecoration(
                                              color:
                                                  colorData.secondaryColor(.5),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                  ],
                ),
              )
            ],
          )
        : const RecentPlaceHolder(
            header: "Recent", text: "No Batches have been crested till NOW!");
  }
}
