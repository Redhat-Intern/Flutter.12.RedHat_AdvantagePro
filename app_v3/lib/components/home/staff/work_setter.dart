import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/text.dart';
import '../../common/text_list.dart';
import 'batch_day_work.dart';

class BatchWorkSetter extends ConsumerStatefulWidget {
  const BatchWorkSetter({
    super.key,
    required this.liveBatches,
  });
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> liveBatches;

  @override
  ConsumerState<BatchWorkSetter> createState() => _BatchWorkSetterState();
}

class _BatchWorkSetterState extends ConsumerState<BatchWorkSetter> {
  int batchIndex = 0;
  int dayIndex = 0;

  void setBatchIndex(int batchIndex) {
    setState(() {
      this.batchIndex = batchIndex;
    });
  }

  String getBatchChild(int index) {
    return widget.liveBatches[index]["name"];
  }

  void setDayIndex(int dayIndex) {
    setState(() {
      this.dayIndex = dayIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot<Map<String, dynamic>> batchData =
        widget.liveBatches[batchIndex];

    String getDayChild(int index) {
      return batchData["dates"][index];
    }

    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Live Batches",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w600,
        ),
        SizedBox(
          height: height * 0.0125,
        ),
        CustomListText(
          data: widget.liveBatches,
          index: batchIndex,
          todo: setBatchIndex,
          getChild: getBatchChild,
        ),
        SizedBox(
          height: height * 0.015,
        ),
        CustomListText(
          data: batchData["dates"],
          todo: setDayIndex,
          index: dayIndex,
          getChild: getDayChild,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Expanded(
          child: BatchDayWork(
            documentSnapshot: widget.liveBatches[batchIndex],
            dayIndex: dayIndex,
          ),
        ),
        SizedBox(
          height: height * 0.01,
        ),
      ],
    );
  }
}
