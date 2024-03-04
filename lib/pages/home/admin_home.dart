import 'package:flutter/material.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/home/admin/create_batch_button.dart';
import '../../components/home/header.dart';
import '../../components/home/admin/recent.dart';
import '../../components/home/admin/search.dart';
import '../../components/home/admin/staffs_list.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(),
        const Search(),
        const Recent(),
        const StaffsList(),
        const CreateBatchButton(),
        SizedBox(
          height: height * 0.02,
        ),
      ],
    );
  }
}
