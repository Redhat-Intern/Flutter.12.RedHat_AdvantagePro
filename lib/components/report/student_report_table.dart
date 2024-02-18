import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';
import 'student_namer.dart';

class StudentReportTable extends ConsumerStatefulWidget {
  const StudentReportTable({
    super.key,
    required this.studentsData,
  });
  final Map<String, Map<String, dynamic>> studentsData;

  @override
  ConsumerState<StudentReportTable> createState() => _StudentReportTableState();
}

class _StudentReportTableState extends ConsumerState<StudentReportTable> {
  String selectedItem = "attendance";
  List<String> searchData = ["attendance", "tests", "exams"];
  LinkedScrollControllerGroup commonCtr = LinkedScrollControllerGroup();

  // Initialize controllers dynamically in initState
  List<ScrollController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= widget.studentsData.length; i++) {
      controllers.add(commonCtr.addAndGet());
    }
  }

  @override
  void dispose() {
    // Dispose controllers in dispose
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Students",
                size: sizeData.subHeader,
                color: colorData.fontColor(.8),
                weight: FontWeight.w700,
              ),
              Container(
                height: height * 0.035,
                padding: EdgeInsets.only(left: width * 0.02),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                    color: colorData.fontColor(.8),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 0,
                  alignment: Alignment.center,
                  hint: CustomText(
                    text: selectedItem.toString()[0].toUpperCase() +
                        selectedItem.toString().substring(1),
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w600,
                  ),
                  dropdownColor: colorData.secondaryColor(1),
                  items: searchData
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: CustomText(
                            text: e.toString()[0].toUpperCase() +
                                e.toString().substring(1),
                            size: sizeData.regular,
                            color: colorData.fontColor(.8),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: width * 0.01),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.studentsData.length + 1,
              itemBuilder: (context, index) {
                // Header
                if (index == 0) {
                  return Container(
                    height: height * .05,
                    margin: EdgeInsets.symmetric(vertical: height * 0.008),
                    child: Row(children: [
                      Expanded(
                        flex: 5,
                        child: CustomText(
                          text: "Name",
                          size: sizeData.medium,
                          color: colorData.fontColor(.8),
                          weight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Expanded(
                        flex: 3,
                        child: ListView.builder(
                          controller: controllers[index],
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) => SizedBox(
                            width: width * .2,
                            child: Center(
                              child: CustomText(
                                text: "Day $index",
                                size: sizeData.medium,
                                color: colorData.fontColor(.8),
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                } else {
                  return Container(
                    height: height * 0.065,
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: StudentReportTableNamer(
                              name: "Student 1",
                              id: "Rhcsa001200",
                              imageUrl: "assets/images/staff1.png"),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Expanded(
                          flex: 3,
                          child: ListView.builder(
                            controller: controllers[index],
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: width * .2,
                                child: Center(
                                  child: CustomText(
                                    text: "text",
                                    color: colorData.fontColor(.9),
                                    weight: FontWeight.w800,
                                    size: sizeData.medium,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
