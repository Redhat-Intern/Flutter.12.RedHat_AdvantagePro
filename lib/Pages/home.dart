import 'package:flutter/material.dart';

import '../Utilities/theme/size_data.dart';

import '../components/home/create_batch_button.dart';
import '../components/home/header.dart';
import '../components/home/recent.dart';
import '../components/home/search.dart';
import '../components/home/staffs_list.dart';
import '../components/home/wisher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    // double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      children: [
        const Header(),
        SizedBox(
          height: height * 0.015,
        ),
        const Wisher(),
        SizedBox(
          height: height * 0.03,
        ),
        const Search(),
        SizedBox(
          height: height * 0.03,
        ),
        const Recent(),
        SizedBox(
          height: height * 0.03,
        ),
        const StaffsList(),
        const Spacer(),
        const CreateBatchButton(),
        const Spacer(),
      ],
    );
  }
}
