import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../common/text.dart';

class StaffsReportList extends ConsumerWidget {
  const StaffsReportList({
    super.key,
    required this.staffsListData,
    required this.adminStaffData,
  });

  final List<Map<String, dynamic>> staffsListData;
  final Map<String, dynamic> adminStaffData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Text
        CustomText(
          text: "Staffs",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w700,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StaffImageButton(
              todo: () {},
              imageUrl:
                  "https://media.istockphoto.com/id/1462151146/photo/hands-growing-a-young-plant.webp?s=2048x2048&w=is&k=20&c=ky5cj_N-nrd8qvbyRuYX-uv8NHltUoScloGoQ10xH2I=",
            ),
            Expanded(
              child: Container(
                height: height * 0.09,
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  top: height * 0.01,
                  bottom: height * 0.01,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: colorData.secondaryColor(.5),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return StaffImageButton(
                      todo: () {},
                      imageUrl:
                          "https://media.istockphoto.com/id/1462151146/photo/hands-growing-a-young-plant.webp?s=2048x2048&w=is&k=20&c=ky5cj_N-nrd8qvbyRuYX-uv8NHltUoScloGoQ10xH2I=",
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class StaffImageButton extends ConsumerWidget {
  const StaffImageButton({
    super.key,
    required this.todo,
    required this.imageUrl,
  });

  final Function todo;
  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () => todo,
      child: Container(
        width: aspectRatio * 115,
        height: aspectRatio * 115,
        margin: EdgeInsets.only(
          right: width * 0.04,
        ),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colorData.secondaryColor(1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Shimmer.fromColors(
                  baseColor: colorData.backgroundColor(.1),
                  highlightColor: colorData.secondaryColor(.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorData.secondaryColor(.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
