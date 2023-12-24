import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';

import '../components/common/text.dart';
import '../components/batch_creation/add_students.dart';
import '../components/batch_creation/assign_staff.dart';
import '../components/batch_creation/avalilable_certifications.dart';
import '../components/batch_creation/batch_button.dart';
import '../components/common/back_button.dart';

class CreateBatch extends ConsumerStatefulWidget {
  const CreateBatch({super.key});

  @override
  ConsumerState<CreateBatch> createState() => _CreateBatchState();
}

class _CreateBatchState extends ConsumerState<CreateBatch> {
  
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(
                    width: width * 0.22,
                  ),
                  CustomText(
                    text: "Batch Creation",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    AvailableCertifications(),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    AssignStaff(),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    AddStudents(),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    BatchButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
