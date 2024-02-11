import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

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
          // Expanded(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(
          //       vertical: height * 0.01,
          //       horizontal: width * 0.02,
          //     ),
          //     child: 
          //   ),
          // ),
        ],
      ),
    );
  }
}
