import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/icon.dart';
import '../common/text.dart';

class Recent extends StatefulWidget {
  Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  TrackingScrollController controller = TrackingScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  List<Map<String, Map<String, dynamic>>> recentBatches = [
    {
      "assets/images/certificate1.png": {"name": "Specialist", "count": 30}
    },
    {
      "assets/images/certificate1.png": {"name": "ADMS", "count": 2}
    },
    {
      "assets/images/certificate1.png": {"name": "ljsd", "count": 23}
    },
    {
      "assets/images/certificate1.png": {
        "name": "Specialisiuiusadt",
        "count": 12
      }
    },
    {
      "assets/images/certificate1.png": {"name": "jkhasd", "count": 6}
    },
    {
      "assets/images/certificate1.png": {"name": "t34df", "count": 45}
    },
    {
      "assets/images/certificate1.png": {"name": "iysdfb", "count": 25}
    }
  ];
  int firstIndex = 0;

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
      final index = itemPositionsListener.itemPositions.value.where((element) {
        final isTopVisible = element.itemLeadingEdge >= 0;
        final isBottomVisible = element.itemTrailingEdge <= 1;
        return isTopVisible && isBottomVisible;
      }).map((item) => item.index);
      setState(() {
        firstIndex = index.first;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

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
              onTap: () {},
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
            color: Colors.white.withOpacity(.4),
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
                        text: recentBatches[firstIndex]
                            .values
                            .first
                            .values
                            .first
                            .toString(),
                        size: sizeData.regular,
                        color: colorData.fontColor(.7),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      CustomText(
                        text: "Student count: ",
                        size: sizeData.small,
                        color: colorData.fontColor(.6),
                      ),
                      CustomText(
                        text: recentBatches[firstIndex]
                            .values
                            .first
                            .values
                            .last
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
                child: ScrollablePositionedList.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  itemCount: recentBatches.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemPositionsListener: itemPositionsListener,
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
                      child: Image.asset(
                        recentBatches[index].keys.first,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


// ListView.builder(
//                     controller: controller,
//                     itemCount: 15,
//                     scrollDirection: Axis.horizontal,
//                     addSemanticIndexes: true,
//                     addAutomaticKeepAlives: true,
//                     physics: const BouncingScrollPhysics(),
                    // itemBuilder: (BuildContext context, int index) {
                    //   double offset = width * 0.25;
                    //   controller.addListener(() {
                    //     print(controller.offset / offset);

                    //     print(offset);
                    //   });
                    //   return Container(
                    //     child: Image.asset(
                    //       "assets/images/certificate1.png",
                    //       width: width * 0.25,
                    //     ),
                    //   );
                    // },
//                   ),