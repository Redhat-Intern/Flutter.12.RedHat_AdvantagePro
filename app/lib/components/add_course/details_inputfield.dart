import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/components/common/network_image.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../add_course/course_image_picker.dart';

class CourseDetail extends ConsumerWidget {
  final TextEditingController name;
  final TextEditingController discription;
  final Function? imageSetter;
  final From from;
  final String? imageURL;

  const CourseDetail({
    super.key,
    required this.name,
    required this.discription,
    this.imageSetter,
    required this.from,
    this.imageURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return DottedBorder(
      color: colorData.secondaryColor(.4),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.02,
      ),
      strokeCap: StrokeCap.round,
      strokeWidth: 2,
      dashPattern: const [14, 4, 6, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: Row(
        children: [
          from == From.add
              ? CourseImagePicker(
                  from: From.add,
                  imageURL: "",
                  setter: imageSetter!,
                )
              : CustomNetworkImage(
                  size: height * 0.12,
                  radius: 8,
                  url: imageURL,
                ),
          SizedBox(
            width: width * 0.02,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: height * 0.045,
                  padding: EdgeInsets.only(left: width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        colorData.secondaryColor(.2),
                        colorData.secondaryColor(.4)
                      ],
                    ),
                  ),
                  child: TextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeData.regular,
                      color: colorData.fontColor(.8),
                      height: 1,
                    ),
                    cursorColor: colorData.primaryColor(1),
                    cursorWidth: 2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: height * 0.018),
                      hintText: "Certification Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.regular,
                        color: colorData.fontColor(.5),
                        height: 1,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.only(left: width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        colorData.secondaryColor(.2),
                        colorData.secondaryColor(.4)
                      ],
                    ),
                  ),
                  child: TextField(
                    controller: discription,
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeData.regular,
                      color: colorData.fontColor(.8),
                      height: 1.5,
                    ),
                    cursorColor: colorData.primaryColor(1),
                    cursorWidth: 2,
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.regular,
                        color: colorData.fontColor(.5),
                        height: 0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
