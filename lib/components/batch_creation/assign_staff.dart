import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/icon.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

import '../../components/common/text.dart';

class AssignStaff extends ConsumerStatefulWidget {
  AssignStaff({super.key});

  @override
  ConsumerState<AssignStaff> createState() => _AssignStaffState();
}

class _AssignStaffState extends ConsumerState<AssignStaff> {
  bool movedOver = false;
  String batchAdmin = "";
  List<String> selectedStaff = [];
  List<String> availableStaff = ["Harish", "Bharathraj", "Shiva", "Bhaargav"];

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
              itemCount: availableStaff.length,
              itemBuilder: (BuildContext context, int index) {
                return Draggable(
                  data: availableStaff[index],
                  onDragCompleted: () {
                    setState(() {
                      availableStaff.removeAt(index);
                    });
                  },
                  // moved child
                  feedback: Container(
                    padding: const EdgeInsets.all(1),
                    margin: EdgeInsets.only(
                      right: width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: colorData.secondaryColor(1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset("assets/images/staff1.png"),
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
                        child: Image.asset(
                          "assets/images/staff1.png",
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
                    child: Image.asset("assets/images/staff1.png"),
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
                  selectedStaff.isEmpty
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
                    onAccept: (data) {
                      setState(() {
                        selectedStaff.add(data.toString());
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
                      itemCount: selectedStaff.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              availableStaff.add(selectedStaff[index]);
                              if (selectedStaff[index] == batchAdmin) {
                                batchAdmin = "";
                              }
                              selectedStaff.removeAt(index);
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              batchAdmin = selectedStaff[index];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                batchAdmin == selectedStaff[index] ? 1 : 3),
                            margin: EdgeInsets.only(
                              right: width * 0.04,
                            ),
                            decoration: BoxDecoration(
                              color: colorData.secondaryColor(1),
                              borderRadius: BorderRadius.circular(8),
                              border: batchAdmin == selectedStaff[index]
                                  ? Border.all(
                                      color: colorData.primaryColor(1),
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      width: 2,
                                    )
                                  : Border.all(
                                      color: Colors.transparent, width: 0),
                            ),
                            child: Image.asset("assets/images/staff1.png"),
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
