import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/drawer_provider.dart';
import '../providers/navigation_index_provider.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/icon.dart';
import '../components/common/text.dart';

class SideBar extends ConsumerStatefulWidget {
  final List<Map<IconData, String>> iconNameList;

  const SideBar({
    required this.iconNameList,
    super.key,
  });

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  @override
  Widget build(BuildContext context) {
    int index = ref.watch(navigationIndexProvider);
    GlobalKey<ScaffoldState> scaffoldKey = ref.read(drawerKeyProvider);

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Drawer(
      backgroundColor: colorData.primaryColor(1),
      width: sizeData.sideBarWith,
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
                    const Icon(Icons.access_alarm_outlined),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    CustomText(
                        text: "Vectra PRO",
                        weight: FontWeight.bold,
                        color: colorData.sideBarTextColor(1),
                        size: sizeData.header),
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
                          color: colorData.sideBarTextColor(1),
                          size: sizeData.subHeader),
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
                            ref
                                .read(navigationIndexProvider.notifier)
                                .jumpTo(currentListIndex);
                            scaffoldKey.currentState?.closeDrawer();
                            // Navigator.pop(context);
                          },
                          child: Container(
                            // duration: const Duration(milliseconds: 100),
                            padding: EdgeInsets.only(
                              top: height * 0.008,
                              bottom: height * 0.008,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: index == currentListIndex
                                    ? Colors.black.withOpacity(.1)
                                    : Colors.transparent),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomIcon(
                                    icon: e.keys.first,
                                    color: index == currentListIndex
                                        ? colorData.sideBarTextColor(1)
                                        : colorData.sideBarTextColor(.7),
                                    size: aspectRatio * 50),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomText(
                                  text: e.values.first.toString(),
                                  color: index == currentListIndex
                                      ? colorData.sideBarTextColor(1)
                                      : colorData.sideBarTextColor(.7),
                                  size: sizeData.regular,
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
