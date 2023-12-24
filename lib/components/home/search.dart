import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:redhat_v1/Utilities/static_data.dart';
import 'package:redhat_v1/components/common/icon.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../../Utilities/theme/color_data.dart';
import '../../Utilities/theme/size_data.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  String selectedItem = "Batch";
  bool searchResult = false;
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header text
        CustomText(
          text: "Search for Batch, Student or Staff",
          size: sizeData.regular,
          color: colorData.fontColor(.6),
          weight: FontWeight.w600,
        ),
        SizedBox(
          height: height * 0.02,
        ),

        // Search Field
        Container(
          height: height * 0.045,
          padding: EdgeInsets.only(
            top: height * 0.005,
            bottom: height * 0.005,
            left: width * 0.015,
            right: width * 0.01,
          ),
          decoration: BoxDecoration(
            color: colorData.secondaryColor(.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: height * 0.035,
                padding: EdgeInsets.only(left: width * 0.02),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                    color: colorData.fontColor(.8),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 0,
                  alignment: Alignment.center,
                  hint: CustomText(
                    text: selectedItem,
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w600,
                  ),
                  items: searchData
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: CustomText(
                            text: e.toString(),
                            size: sizeData.regular,
                            color: colorData.fontColor(.8),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value.toString();
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: width * 0.03),
                  child: TextField(
                    scrollPadding: EdgeInsets.zero,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: aspectRatio * 33,
                      color: colorData.fontColor(.8),
                      height: 0,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter the ID",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.medium,
                        color: colorData.fontColor(.5),
                        height: 0,
                      ),
                      contentPadding: EdgeInsets.only(
                        bottom: height * 0.015,
                      ),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: CustomIcon(
                          icon: Icons.search_rounded,
                          color: colorData.fontColor(.6),
                          size: aspectRatio * 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Searched Data
        searchResult
            ? Container(
                margin: EdgeInsets.only(top: height * 0.01),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.01,
                  vertical: height * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorData.fontColor(.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorData.primaryColor(.2),
                            colorData.primaryColor(1)
                          ],
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.005,
                      ),
                      child: CustomText(
                        text: "RHCSA",
                        size: sizeData.regular,
                        color: colorData.secondaryColor(1),
                      ),
                    ),
                    CustomText(
                      text: "Batch Started At: 3rd March 2022",
                      color: colorData.fontColor(.5),
                      size: aspectRatio * 28,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
