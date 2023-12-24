import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';
import 'batch_field_tile.dart';

class AvailableCertifications extends ConsumerStatefulWidget {
  const AvailableCertifications({super.key});

  @override
  ConsumerState<AvailableCertifications> createState() =>
      _AvailableCertificationsState();
}

class _AvailableCertificationsState extends ConsumerState<AvailableCertifications> {
  TrackingScrollController controller = TrackingScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Map<String, Map<String, String>> selectedCertificate = {};

  List<Map<String, Map<String, String>>> certifications = [
    {
      "assets/images/certificate1.png": {
        "name": "Specialist",
        "batchNO": "RHCSA001"
      }
    },
    {
      "assets/images/certificate1.png": {"name": "ADMS", "batchNO": "RHCSA002"}
    },
    {
      "assets/images/certificate1.png": {"name": "ljsd", "batchNO": "RHCSA002"}
    },
    {
      "assets/images/certificate1.png": {
        "name": "Specialisiuiusadt",
        "batchNO": "RHCSA002"
      }
    },
    {
      "assets/images/certificate1.png": {
        "name": "jkhasd",
        "batchNO": "RHCSA002"
      }
    },
    {
      "assets/images/certificate1.png": {"name": "t34df", "batchNO": "RHCSA002"}
    },
    {
      "assets/images/certificate1.png": {
        "name": "iysdfb",
        "batchNO": "RHCSA002"
      }
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
    CustomColorData colorData = CustomColorData.from(ref);

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
              text: "Available Certificates",
              size: sizeData.medium,
              color: colorData.fontColor(.8),
              weight: FontWeight.w600,
            ),
            selectedCertificate.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCertificate = {};
                      });
                    },
                    child: CustomText(
                      text: "Change",
                      size: sizeData.medium,
                      color: colorData.primaryColor(1),
                      weight: FontWeight.w800,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        SizedBox(
          height: height * 0.0125,
        ),
        selectedCertificate.isEmpty
            ? Container(
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
                              text: certifications[firstIndex]
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
                              text: "Batch NO: ",
                              size: sizeData.small,
                              color: colorData.fontColor(.6),
                            ),
                            CustomText(
                              text: certifications[firstIndex]
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
                        itemCount: certifications.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemPositionsListener: itemPositionsListener,
                        itemBuilder: (BuildContext context, int index) {
                          bool isFirst = firstIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCertificate = certifications[index];
                              });
                            },
                            child: Container(
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
                                certifications[index].keys.first,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: height * 0.015,
                      bottom: height * 0.015,
                      left: width * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color: colorData.secondaryColor(.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(selectedCertificate.keys.first),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BatchFieldTile(
                              field:
                                  selectedCertificate.values.first.keys.first,
                              value:
                                  selectedCertificate.values.first.values.first,
                            ),
                            BatchFieldTile(
                              field: selectedCertificate.values.last.keys.last,
                              value:
                                  selectedCertificate.values.last.values.last,
                            ),
                            BatchFieldTile(
                              field: "start",
                              value:
                                  selectedCertificate.values.last.values.last,
                            ),
                            BatchFieldTile(
                              field: "end",
                              value:
                                  selectedCertificate.values.last.values.last,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: width * 0.02,
                    bottom: height * 0.01,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: colorData.primaryColor(.8),
                      ),
                      child: CustomText(
                        text: "SET DATE",
                        size: sizeData.small,
                        color: colorData.secondaryColor(1),
                        weight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
      ],
    );
  }
}