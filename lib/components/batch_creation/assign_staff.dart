import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';
import 'package:redhat_v1/providers/create_batch_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../../components/common/text.dart';

class AssignStaff extends ConsumerStatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  const AssignStaff({
    super.key,
    required this.docs,
  });

  @override
  ConsumerState<AssignStaff> createState() => _AssignStaffState();
}

class _AssignStaffState extends ConsumerState<AssignStaff> {
  bool movedOver = false;
  Map<String, dynamic> batchAdmin = {};
  List<Map<String, dynamic>> selectedStaffs = [];
  List<Map<String, dynamic>> availableStaffs = [];

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> availableStaffsList = [];
    for (var element in widget.docs) {
      Map<String, dynamic> value =
          Map.fromEntries(element.data().entries.toSet());
      value.addAll({"email": element.id.toString()});
      availableStaffsList.add(value);
    }
    setState(() {
      availableStaffs = availableStaffsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Assign Staffs",
            size: sizeData.medium,
            color: colorData.fontColor(.8),
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          CustomText(
            text: "Available staffs",
            size: sizeData.small,
            color: colorData.fontColor(.6),
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            height: height * 0.07,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              itemCount: availableStaffs.length,
              itemBuilder: (BuildContext context, int index) {
                return Draggable(
                  data: availableStaffs[index],
                  onDragCompleted: () {
                    setState(() {
                      availableStaffs.removeAt(index);
                    });
                  },
                  // moved child
                  feedback: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1),
                        margin: EdgeInsets.only(
                          right: width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: colorData.secondaryColor(1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            availableStaffs[index]["photo"],
                            width: aspectRatio * 120,
                            height: aspectRatio * 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CustomText(
                        text: availableStaffs[index]["name"],
                        size: sizeData.regular,
                        color: colorData.fontColor(.8),
                        weight: FontWeight.bold,
                      )
                    ],
                  ),
                  // child replaced place
                  childWhenDragging: Container(
                    margin: EdgeInsets.only(
                      right: width * 0.04,
                    ),
                    child: DottedBorder(
                      color: colorData.primaryColor(1),
                      padding: const EdgeInsets.all(4),
                      strokeCap: StrokeCap.round,
                      strokeWidth: 2,
                      dashPattern: const [10, 4, 6, 4],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            availableStaffs[index]["photo"],
                            width: aspectRatio * 85,
                            height: aspectRatio * 85,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // child
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    margin: EdgeInsets.only(
                      right: width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: colorData.secondaryColor(1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        availableStaffs[index]["photo"],
                        width: aspectRatio * 100,
                        height: aspectRatio * 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: colorData.backgroundColor(.1),
                              highlightColor: colorData.secondaryColor(.1),
                              child: Container(
                                width: aspectRatio * 100,
                                height: aspectRatio * 100,
                                decoration: BoxDecoration(
                                  color: colorData.secondaryColor(.5),
                                  borderRadius: BorderRadius.circular(8.0),
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
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: "Selected Staff",
                size: sizeData.small,
                color: colorData.fontColor(.6),
                weight: FontWeight.w600,
              ),
              Tooltip(
                message: "Long Press a staff\n to make him as Batch Admin",
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorData.fontColor(.6),
                  fontSize: sizeData.small,
                ),
                waitDuration: const Duration(microseconds: 1),
                showDuration: const Duration(milliseconds: 800),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.005),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorData.secondaryColor(.8),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorData.secondaryColor(.5),
                  ),
                  child: CustomIcon(
                    size: aspectRatio * 32,
                    icon: Icons.question_mark_rounded,
                    color: colorData.primaryColor(1),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            borderPadding: EdgeInsets.only(left: width * 0.02),
            color: movedOver
                ? colorData.primaryColor(1)
                : colorData.secondaryColor(.4),
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            dashPattern: const [8, 4, 6, 4],
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: height * 0.01,
            ),
            child: SizedBox(
              height: height * 0.07,
              child: Stack(
                children: [
                  selectedStaffs.isEmpty
                      ? Center(
                          child: CustomText(
                            text: "Drag the staffs here to select them",
                            size: sizeData.medium,
                            color: colorData.fontColor(.15),
                            weight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                  DragTarget(
                    onAccept: (Map<String, dynamic> data) {
                      setState(() {
                        selectedStaffs.add(data);
                        ref.read(createBatchProvider.notifier).updateStaffs(
                            newStaffs: selectedStaffs
                                .map((e) => e["email"].toString())
                                .toList());
                        movedOver = false;
                      });
                    },
                    onMove: (obj) {
                      setState(() {
                        movedOver = true;
                      });
                    },
                    onLeave: (obj) {
                      setState(() {
                        movedOver = false;
                      });
                    },
                    builder: (context, accept, reject) => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      itemCount: selectedStaffs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              availableStaffs.add(selectedStaffs[index]);
                              if (selectedStaffs[index]["name"] ==
                                  batchAdmin["name"]) {
                                batchAdmin = {};
                                ref
                                    .read(createBatchProvider.notifier)
                                    .updateAdminStaff(adminStaff: '');
                              }
                              selectedStaffs.removeAt(index);
                              ref
                                  .read(createBatchProvider.notifier)
                                  .updateStaffs(
                                      newStaffs: selectedStaffs
                                          .map((e) => e["email"].toString())
                                          .toList());
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              batchAdmin = selectedStaffs[index];
                              ref
                                  .read(createBatchProvider.notifier)
                                  .updateAdminStaff(
                                      adminStaff: selectedStaffs[index]
                                          ["email"]);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              batchAdmin["name"] ==
                                      selectedStaffs[index]["name"]
                                  ? 1
                                  : 3,
                            ),
                            margin: EdgeInsets.only(
                              right: width * 0.04,
                            ),
                            decoration: BoxDecoration(
                              color: colorData.secondaryColor(1),
                              borderRadius: BorderRadius.circular(8),
                              border: batchAdmin["name"] ==
                                      selectedStaffs[index]["name"]
                                  ? Border.all(
                                      color: colorData.primaryColor(1),
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      width: 2,
                                    )
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                selectedStaffs[index]["photo"],
                                width: aspectRatio * 95,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
