import 'package:flutter/material.dart';
import 'package:redhat_v1/components/common/icon.dart';

import '../Utilities/theme/color_data.dart';
import '../Utilities/theme/size_data.dart';
import '../components/common/text.dart';

class SideBar extends StatefulWidget {
  final int index;
  final Function indexShifter;
  final List<Map<IconData, String>> iconNameList;

  const SideBar({
    required this.index,
    required this.indexShifter,
    required this.iconNameList,
    super.key,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Drawer(
      backgroundColor: colorData.sideBarColor,
      width: sizeData.sizeBarWith,
      child: Builder(builder: (context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.only(
                top: height * 0.02, left: width * 0.04, right: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Icon(Icons.access_alarm_outlined),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    CustomText(
                        text: "Vectra PRO",
                        weight: FontWeight.bold,
                        color: Colors.white,
                        size: sizeData.headerSize),
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width * 0.02),
                      child: CustomText(
                          text: "Main",
                          color: Colors.white,
                          size: sizeData.subHeaderSize),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    // SideBar navigator buttons list
                    ...widget.iconNameList.map(
                      (e) {
                        int currentListIndex = widget.iconNameList.indexOf(e);
                        return GestureDetector(
                          onTap: () {
                            widget.indexShifter(currentListIndex);
                            Navigator.pop(context);
                          },
                          child: Container(
                            // duration: const Duration(milliseconds: 100),
                            padding: EdgeInsets.only(
                              top: height * 0.008,
                              bottom: height * 0.008,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: widget.index == currentListIndex
                                    ? Colors.black.withOpacity(.1)
                                    : Colors.transparent),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomIcon(
                                    icon: e.keys.first,
                                    color: widget.index == currentListIndex
                                        ? colorData.sideBarIconColor
                                        : colorData.sideBarTextColor(.7),
                                    size: aspectRatio * 48),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomText(
                                  text: e.values.first.toString(),
                                  color: widget.index == currentListIndex
                                      ? colorData.sideBarTextColor(1)
                                      : colorData.sideBarTextColor(.7),
                                  size: sizeData.textSize,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
