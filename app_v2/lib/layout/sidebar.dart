import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/drawer_provider.dart';
import '../utilities/routes.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/icon.dart';
import '../components/common/text.dart';

class SideBar extends ConsumerStatefulWidget {
  final List<Map<IconData, String>> iconNameList;
  final int index;

  const SideBar({
    required this.iconNameList,
    required this.index,
    super.key,
  });

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  List<String> routeNames = [
    Routes.homeName,
    Routes.forumName,
    Routes.reportName,
    Routes.coursesName
  ];
  @override
  Widget build(BuildContext context) {
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
                    Image.asset(
                      "assets/images/logo.png",
                      height: aspectRatio * 100,
                      width: aspectRatio * 100,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    CustomText(
                      text: "Vectra\nTechnosoft".toUpperCase(),
                      weight: FontWeight.bold,
                      color: colorData.sideBarTextColor(1),
                      size: sizeData.header,
                      fontFamily: "Merriweather",
                      maxLine: 2,
                      align: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
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
                            GoRouter.of(context)
                                .goNamed(routeNames[currentListIndex]);
                            scaffoldKey.currentState?.closeDrawer();
                          },
                          child: Container(
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
                                        ? colorData.sideBarTextColor(1)
                                        : colorData.sideBarTextColor(.7),
                                    size: aspectRatio * 50),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                CustomText(
                                  text: e.values.first.toString(),
                                  color: widget.index == currentListIndex
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
