import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class StudentReportTableNamer extends ConsumerWidget {
  const StudentReportTableNamer({
    super.key,
    required this.name,
    required this.id,
    required this.imageUrl,
  });

  final String name;
  final String id;
  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.005),
      child: Row(children: [
        Container(
          width: height * 0.055,
          height: double.infinity,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorData.secondaryColor(1),
          ),
          child: imageUrl.length == 1
              ? Center(
                  child: CustomText(
                    text: imageUrl.toUpperCase(),
                    color: colorData.fontColor(1),
                    weight: FontWeight.bold,
                    size: height * 0.05,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imageUrl)),
        ),
        SizedBox(
          width: width * 0.02,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: name[0].toUpperCase() + name.substring(1),
                  size: sizeData.medium,
                  color: colorData.fontColor(.9),
                  weight: FontWeight.w800),
              CustomText(
                text: id.toUpperCase(),
                size: sizeData.small,
                color: colorData.fontColor(.6),
                weight: FontWeight.w800,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
