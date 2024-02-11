import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/firebase/create/create_save_batch.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../firebase/update/certificate_batchlist.dart';
import '../../providers/create_batch_provider.dart';
import '../common/text.dart';

class BatchButton extends ConsumerWidget {
  const BatchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            ref.read(createBatchProvider.notifier).updateTime();
            createBatch(batch: ref.watch(createBatchProvider));
            await updateBatchList(
              certificateName: ref.watch(createBatchProvider).certificateData["name"],
              batch: ref.watch(createBatchProvider).name,
            );
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
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.008,
              horizontal: width * 0.02,
            ),
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
              text: "Create Batch",
              size: sizeData.regular,
              color: colorData.secondaryColor(1),
              weight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.14,
        ),
        GestureDetector(
          onTap: () async {
            ref.read(createBatchProvider.notifier).updateTime();
            saveBatch(batch: ref.watch(createBatchProvider));
            await updateBatchList(
              certificateName: ref.watch(createBatchProvider).certificateData["name"],
              batch: ref.watch(createBatchProvider).name,
            );
            ref.read(createBatchProvider.notifier).clearData();
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
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.008,
              horizontal: width * 0.02,
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
              text: "Save Batch",
              size: sizeData.regular,
              color: colorData.fontColor(.8),
              weight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
