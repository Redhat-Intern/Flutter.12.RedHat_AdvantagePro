import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../shimmer_box.dart';

class CertificationWaitingWidget extends ConsumerWidget {
  const CertificationWaitingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: sizeData.superHeader, width: width * .2),
        SizedBox(height: height * 0.0125),
        Container(
          decoration: BoxDecoration(
            color: colorData.secondaryColor(.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: SizedBox(
            height: height * 0.185,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
              ),
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Opacity(
                  opacity: 1 - (index * .3),
                  child: Container(
                    margin: EdgeInsets.only(right: width * 0.03),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.015),
                        ShimmerBox(
                            height: sizeData.regular, width: width * .15),
                        SizedBox(height: height * 0.01),
                        ShimmerBox(height: height * .125, width: height * .125)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
