import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';

class Staffs extends StatelessWidget {
  const Staffs({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        // Header Text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: "Staffs",
              size: sizeData.subHeader,
              color: colorData.fontColor(.8),
              weight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "All",
                    size: sizeData.medium,
                    color: colorData.fontColor(.8),
                  ),
                  CustomIcon(
                    size: sizeData.subHeader,
                    icon: Icons.arrow_forward_ios_rounded,
                    color: colorData.fontColor(.8),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.0125,
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                margin:
                    EdgeInsets.only(right: width * 0.02, left: width * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIcon(
                  size: aspectRatio * 60,
                  icon: Icons.add_rounded,
                  color: colorData.fontColor(.7),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: height * 0.075,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: const EdgeInsets.all(1),
                          margin: EdgeInsets.only(
                            right: width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset("assets/images/staff1.png"));
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
