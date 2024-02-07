import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:redhat_v1/providers/create_batch_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../common/text.dart';
import 'batch_field_tile.dart';

class AvailableCertifications extends ConsumerStatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  const AvailableCertifications({
    super.key,
    required this.docs,
  });

  @override
  ConsumerState<AvailableCertifications> createState() =>
      _AvailableCertificationsState();
}

class _AvailableCertificationsState
    extends ConsumerState<AvailableCertifications> {
  final ScrollController _controller = ScrollController();

  List<Map<String, dynamic>> certifications = [];
  Map<String, dynamic> selectedCertificate = {};

  DateTime? startDate;
  DateTime? endDate;

  Future<void> selectDate({
    required BuildContext context,
    required int days,
    required Size size,
    required CustomColorData colorData,
    required CustomSizeData sizeData,
  }) async {
    List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDayOfWeek: 1,
        currentDate: DateTime.now(),
        firstDate: DateTime.now(),
        dayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorData.fontColor(.6),
          fontSize: sizeData.small,
        ),
        selectedDayTextStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: colorData.secondaryColor(1),
          fontSize: sizeData.regular,
        ),
        calendarType: CalendarDatePicker2Type.multi,
        selectedDayHighlightColor: colorData.primaryColor(.8),
        centerAlignModePicker: true,
      ),
      dialogSize: size,
    );
    if (dates != null && dates.isNotEmpty) {
      setState(() {
        startDate = dates.first;
        endDate = dates.last;
        List<String> selectedDates =
            dates.map((e) => DateFormat('dd-MM-yyyy').format(e!)).toList();

        ref.read(createBatchProvider.notifier).updateCertificate(
              newCertificateName: selectedCertificate["name"],
              newCertificateImg: selectedCertificate["image"],
            );

        ref
            .read(createBatchProvider.notifier)
            .updateDates(newDates: selectedDates);
      });
    }
  }

  void setBatchName() {
    String batchName = selectedCertificate["name"] + "001";
    List<dynamic> registeredBatches = selectedCertificate["batches"] ?? [];

    if (registeredBatches.isNotEmpty) {
      String lastBatch = registeredBatches.last;
      int batchesCount =
          int.parse(lastBatch.substring(lastBatch.length - 3).toString()) + 1;
      batchName =
          selectedCertificate["name"] + batchesCount.toString().padLeft(3, '0');
    }
    ref.read(createBatchProvider.notifier).updateName(newName: batchName);
  }

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> certificationsData = [];
    for (var element in widget.docs) {
      Map<String, dynamic> value =
          Map.fromEntries(element.data().entries.toSet());
      value.addAll({"id": element.id.toString()});
      certificationsData.add(value);
    }
    setState(() {
      certifications = certificationsData;
    });
  }

  int firstIndex = 0;

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

    String batchName = ref.watch(createBatchProvider).name;

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
                              text:
                                  certifications[firstIndex]["name"].toString(),
                              size: sizeData.regular,
                              color: colorData.fontColor(.7),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    SizedBox(
                      height: height * 0.14,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo is ScrollUpdateNotification) {
                            // Check the first visible item index
                            int firstVisibleItemIndex =
                                (_controller.position.maxScrollExtent > 0
                                    ? ((_controller.position.pixels /
                                                _controller
                                                    .position.maxScrollExtent) *
                                            (certifications.length - 1))
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
                          itemCount: certifications.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            bool isFirst = firstIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCertificate = certifications[index];
                                  setBatchName();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: width * 0.02),
                                padding: EdgeInsets.all(isFirst ? 3 : 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: isFirst
                                          ? colorData.primaryColor(.6)
                                          : Colors.transparent,
                                      width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    certifications[index]["image"],
                                    fit: BoxFit.fill,
                                    width: width * 0.225,
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
                                            width: width * 0.225,
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
                              ),
                            );
                          },
                        ),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            selectedCertificate["image"],
                            height: height * 0.125,
                            width: width * 0.225,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BatchFieldTile(
                              field: "NAME",
                              value: selectedCertificate["name"],
                            ),
                            BatchFieldTile(
                              field: "duration",
                              value:
                                  "${Map.from(selectedCertificate["courseContent"]).length} Days",
                            ),
                            BatchFieldTile(
                              field: "start",
                              value: startDate == null
                                  ? "set startDate"
                                  : DateFormat('dd-MM-yyyy').format(startDate!),
                            ),
                            BatchFieldTile(
                              field: "end",
                              value: endDate == null
                                  ? "set endDate"
                                  : DateFormat('dd-MM-yyyy').format(endDate!),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  batchName != ""
                      ? Positioned(
                          right: width * 0.02,
                          top: height * 0.01,
                          child: GestureDetector(
                            onTap: () => selectDate(
                              context: context,
                              days:
                                  Map.from(selectedCertificate["courseContent"])
                                      .length,
                              size: Size(width * .8, height * 0.3),
                              colorData: colorData,
                              sizeData: sizeData,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: colorData.backgroundColor(.8),
                              ),
                              child: CustomText(
                                text: batchName,
                                size: sizeData.small,
                                color: colorData.primaryColor(1),
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Positioned(
                    right: width * 0.02,
                    bottom: height * 0.01,
                    child: GestureDetector(
                      onTap: () => selectDate(
                        context: context,
                        days: Map.from(selectedCertificate["courseContent"])
                            .length,
                        size: Size(width * .8, height * 0.3),
                        colorData: colorData,
                        sizeData: sizeData,
                      ),
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
                    ),
                  )
                ],
              ),
      ],
    );
  }
}
