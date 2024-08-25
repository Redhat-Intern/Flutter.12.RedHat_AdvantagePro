import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/add_staff/custom_input_field.dart';
import '../../components/common/page_header.dart';
import '../../components/home/student/certifications_place_holder.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../providers/create_batch_provider.dart';

import '../../components/batch_creation/preview.dart';
import '../../components/batch_creation/add_students.dart';
import '../../components/batch_creation/assign_staff.dart';
import '../../components/batch_creation/avalilable_certifications.dart';
import '../../components/batch_creation/batch_button.dart';

class CreateSavedBatch extends ConsumerWidget {
  const CreateSavedBatch({
    super.key,
    required this.courseID,
    required this.name,
    required this.selectDates,
    required this.staffID,
  });

  final String name;
  final String courseID;
  final List<String> selectDates;
  final List<String> staffID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double width = sizeData.width;

    // double aspectRatio = sizeData.aspectRatio;

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
              PageHeader(
                tittle: "create batch",
                isMenuButton: false,
                otherMethod: () =>
                    ref.read(createBatchProvider.notifier).clearData(),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    CustomInputField(
                      hintText: "Enter the Batch ID",
                      icon: Icons.badge_rounded,
                      inputType: TextInputType.text,
                      readOnly: true,
                      initialValue: name,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("courses")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            QueryDocumentSnapshot<Map<String, dynamic>> doc =
                                snapshot.data!.docs.firstWhere(
                                    (element) => element.id == courseID);
                            return AvailableCertifications(
                              doc: doc,
                              from: From.detail,
                              dates: selectDates,
                            );
                          } else {
                            return const CertificationsPlaceHolder();
                          }
                        }),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("userRole", isEqualTo: "staff")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                docs = snapshot.data!.docs
                                    .where((element) =>
                                        staffID.contains(element.data()["id"]))
                                    .toList();
                            return AssignStaff(
                              from: From.detail,
                              docs: docs,
                            );
                          } else {
                            return const Text(
                              "loading",
                            );
                          }
                        }),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    const AddStudents(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ref.watch(createBatchProvider).students.isNotEmpty
                        ? const DataPreview()
                        : const SizedBox(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const BatchButton(isSaveButton: false),
                    SizedBox(
                      height: height * 0.05,
                    ),
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
