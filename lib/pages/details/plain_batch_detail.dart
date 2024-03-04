import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/home/admin/staffs_list_place_holder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../components/common/page_header.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/common/back_button.dart';
import '../../components/common/text.dart';

class PlainBatchDetail extends ConsumerWidget {
  const PlainBatchDetail({super.key, required this.batchData});
  final Map<String, dynamic> batchData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              PageHeader(tittle: "batch detail"),
            ],
          ),
        ),
      ),
    );
  }
}
