import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/theme/size_data.dart';

import '../components/common/shimmer_box.dart';
import '../components/common/waiting_widgets/header_waiting.dart';
import '../components/common/waiting_widgets/recent_waiting.dart';
import '../components/common/waiting_widgets/search_field_waiting.dart';
import '../components/common/waiting_widgets/staffs_list_waiting.dart';

class LoadingPage extends ConsumerWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MainPageHeaderWaitingWidget(),
              const SearchFieldWaitingWidget(),
              const RecentWaitingWidget(),
              const StaffsListWaiting(),
              ShimmerBox(height: height * 0.1, width: width * 0.45),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
