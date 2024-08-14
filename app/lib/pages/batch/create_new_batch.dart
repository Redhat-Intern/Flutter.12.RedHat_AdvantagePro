import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/add_staff/custom_input_field.dart';

import '../../components/common/page_header.dart';
import '../../components/home/student/certifications_place_holder.dart';
import '../../utilities/theme/size_data.dart';
import '../../providers/create_batch_provider.dart';

import '../../components/batch_creation/preview.dart';
import '../../components/batch_creation/add_students.dart';
import '../../components/batch_creation/assign_staff.dart';
import '../../components/batch_creation/avalilable_certifications.dart';
import '../../components/batch_creation/batch_button.dart';

class CreateNewBatch extends ConsumerWidget {
  const CreateNewBatch({super.key});

  void clearData(WidgetRef ref) {
    ref.read(createBatchProvider.notifier).clearData();
  }

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
                      listener:
                          ref.read(createBatchProvider.notifier).setBatchName,
                      hintText: "Enter the Batch ID",
                      icon: Icons.badge_rounded,
                      inputType: TextInputType.text,
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
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                docs = snapshot.data!.docs;
                            return AvailableCertifications(
                              docs: docs,
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
                                docs = snapshot.data!.docs;
                            return AssignStaff(
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
                    const BatchButton(),
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
