import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/functions/create/create_save_batch.dart';

import '../../model/batch.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            ref.read(createBatchProvider.notifier).updateTime();
            Batch batchData = ref.watch(createBatchProvider);
        
            if (!batchData.isEmpty()) {
              createBatch(batch: batchData);
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
      ],
    );
    //      Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     GestureDetector(
    //       onTap: () async {
    //         ref.read(createBatchProvider.notifier).updateTime();
    //         Batch batchData = ref.watch(createBatchProvider);

    //         if (!batchData.isEmpty()) {
    //           createBatch(batch: batchData);
    //           ref.read(createBatchProvider.notifier).clearData();
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(
    //                 content: Center(
    //               child: CustomText(
    //                 text: "Batch Created Successfuly",
    //                 color: Colors.white,
    //                 weight: FontWeight.w700,
    //               ),
    //             )),
    //           );
    //           Navigator.pop(context);
    //         } else {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(
    //                 content: Center(
    //               child: CustomText(
    //                 text: "Kindly fill all the details!",
    //                 color: Colors.white,
    //                 weight: FontWeight.w700,
    //               ),
    //             )),
    //           );
    //         }
    //       },
    //       child: Container(
    //         padding: EdgeInsets.symmetric(
    //           vertical: height * 0.008,
    //           horizontal: width * 0.02,
    //         ),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8),
    //           gradient: LinearGradient(
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             colors: [
    //               colorData.primaryColor(.4),
    //               colorData.primaryColor(1),
    //             ],
    //           ),
    //         ),
    //         child: CustomText(
    //           text: "Create Batch",
    //           size: sizeData.regular,
    //           color: colorData.secondaryColor(1),
    //           weight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       width: width * 0.14,
    //     ),
    //     GestureDetector(
    //       onTap: () async {
    //         ref.read(createBatchProvider.notifier).updateTime();
    //         Batch batchData = ref.watch(createBatchProvider);

    //         if (!batchData.isEmpty()) {
    //           ref.read(createBatchProvider.notifier).clearData();
    //           saveBatch(batch: batchData);
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(
    //                 content: Center(
    //               child: CustomText(
    //                 text: "Batch Saved Successfuly",
    //                 color: Colors.white,
    //                 weight: FontWeight.w700,
    //               ),
    //             )),
    //           );
    //           Navigator.pop(context);
    //         } else {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(
    //                 content: Center(
    //               child: CustomText(
    //                 text: "Kindly fill all the details!",
    //                 color: Colors.white,
    //                 weight: FontWeight.w700,
    //               ),
    //             )),
    //           );
    //         }
    //       },
    //       child: Container(
    //         padding: EdgeInsets.symmetric(
    //           vertical: height * 0.008,
    //           horizontal: width * 0.02,
    //         ),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8),
    //           gradient: LinearGradient(
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             colors: [
    //               colorData.secondaryColor(.2),
    //               colorData.secondaryColor(.8),
    //             ],
    //           ),
    //         ),
    //         child: CustomText(
    //           text: "Save Batch",
    //           size: sizeData.regular,
    //           color: colorData.fontColor(.8),
    //           weight: FontWeight.w800,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
