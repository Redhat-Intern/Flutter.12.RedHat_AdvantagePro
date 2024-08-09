import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/utilities/static_data.dart';
import 'package:redhat_v1/providers/create_batch_provider.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../model/student.dart';
import 'add_individual_student_overlay.dart';

class DataPreview extends ConsumerWidget {
  const DataPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Student> excelData = ref.watch(createBatchProvider).students;
    List<String> columns = [
      "RegistrationID",
      "Name",
      "Email",
      "PhoneNO",
      "Occupation",
      "Occupation Detail",
      "Edit",
      "Delete",
    ];

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorData.secondaryColor(.3),
      ),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.02,
      ),
      height: height * 0.3,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: DataTable(
              dataRowMaxHeight: height * 0.06,
              dataRowMinHeight: height * 0.06,
              columnSpacing: width * 0.05,
              dividerThickness: .3,
              headingRowHeight: height * 0.06,
              headingRowColor:
                  WidgetStatePropertyAll(colorData.backgroundColor(1)),
              dataTextStyle: TextStyle(
                fontSize: sizeData.regular,
                fontWeight: FontWeight.w600,
                color: colorData.fontColor(.6),
              ),
              headingTextStyle: TextStyle(
                fontSize: sizeData.regular,
                fontWeight: FontWeight.w800,
                color: colorData.fontColor(.8),
              ),
              columns: columns
                  .map((e) => DataColumn(
                        label: Text(
                          e.toString(),
                        ),
                      ))
                  .toList(),
              rows: List.generate(
                excelData.length,
                (index) {
                  Student stuData = excelData[index];
                  List<dynamic> rowData = [
                    stuData.registrationID,
                    stuData.name,
                    stuData.email,
                    stuData.phoneNo,
                    stuData.occupation.name,
                    stuData.occDetail,
                    1,
                    2
                  ];
                  return DataRow(
                    cells: rowData.map((cellValue) {
                      if (cellValue == 1 || cellValue == 2) {
                        return DataCell(
                            Center(
                              child: cellValue == 1
                                  ? const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                    ),
                            ), onTap: () {
                          if (cellValue == 1) {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) {
                                return AddIndividualStudentOverlay(
                                  from: From.edit,
                                  data: stuData,
                                );
                              },
                            );
                          } else {
                            ref
                                .read(createBatchProvider.notifier)
                                .removeStudent(student: stuData);
                          }
                        });
                      } else {
                        return DataCell(
                          Text(cellValue.toString()),
                        );
                      }
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
