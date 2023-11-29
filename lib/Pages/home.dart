import 'package:flutter/material.dart';

import '../Utilities/theme/size_data.dart';

import '../components/home/create_batch_button.dart';
import '../components/home/header.dart';
import '../components/home/recent.dart';
import '../components/home/search.dart';
import '../components/home/staffs.dart';
import '../components/home/wisher.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      children: [
        Header(),
        SizedBox(
          height: height * 0.015,
        ),
        Wisher(),
        SizedBox(
          height: height * 0.03,
        ),
        Search(),
        SizedBox(
          height: height * 0.03,
        ),
        Recent(),
        SizedBox(
          height: height * 0.03,
        ),
        Staffs(),
        const Spacer(),
        CreateBatchButton(),
        const Spacer(),
      ],
    );
  }
}
