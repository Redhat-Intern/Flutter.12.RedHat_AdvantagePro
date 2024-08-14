import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/functions/create/create_save_batch.dart';

import '../../model/batch.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../providers/create_batch_provider.dart';
import '../common/text.dart';

class BatchButton extends ConsumerWidget {
  const BatchButton(
      {super.key, this.isCreateButton = true, this.isSaveButton = true});
  final bool? isSaveButton;
  final bool? isCreateButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isCreateButton!)
          GestureDetector(
            onTap: () async {
              ref.read(createBatchProvider.notifier).updateTime();
              Batch batchData = ref.watch(createBatchProvider);

              if (batchData.isNotEmpty(needStudentCheck: true)) {
                if (await uniqueIDCheck(
                    batchID: batchData.name.toUpperCase(),
                    collName: "batches")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Center(
                      child: CustomText(
                        text: "Batch ID already exists in BATCHES",
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    )),
                  );
                } else {
                  createBatch(batch: batchData, ref: ref);
                  ref.read(createBatchProvider.notifier).clearData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Center(
                      child: CustomText(
                        text: "Batch Created Successfuly",
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    )),
                  );
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Center(
                    child: CustomText(
                      text: "Kindly fill all the details!",
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  )),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: width * 0.08,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorData.primaryColor(.4),
                    colorData.primaryColor(1),
                  ],
                ),
              ),
              child: CustomText(
                text: "CREATE BATCH",
                size: sizeData.regular,
                color: colorData.secondaryColor(1),
                weight: FontWeight.w600,
              ),
            ),
          ),
        if (isCreateButton! && isSaveButton!) const Spacer(),
        if (isSaveButton!)
          GestureDetector(
            onTap: () async {
              ref.read(createBatchProvider.notifier).updateTime();
              Batch batchData = ref.watch(createBatchProvider);

              if (batchData.isNotEmpty(needStudentCheck: false)) {
                if (await uniqueIDCheck(
                    batchID: batchData.name.toUpperCase(),
                    collName: "batches")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Center(
                      child: CustomText(
                        text: "Batch ID already exists in BATCHES",
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    )),
                  );
                } else if (await uniqueIDCheck(
                    batchID: batchData.name.toUpperCase(),
                    collName: "savedBatches")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Center(
                      child: CustomText(
                        text: "Batch ID already exists in SAVED BATCHES",
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    )),
                  );
                } else {
                  saveBatch(batch: batchData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Center(
                      child: CustomText(
                        text: "Batch Saved Successfuly",
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    )),
                  );
                  ref.read(createBatchProvider.notifier).clearData();
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Center(
                    child: CustomText(
                      text: "Kindly fill all the details!",
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  )),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: width * 0.08,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorData.secondaryColor(.2),
                    colorData.secondaryColor(.8),
                  ],
                ),
              ),
              child: CustomText(
                text: "SAVE BATCH",
                size: sizeData.medium,
                color: colorData.fontColor(.8),
                weight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}
