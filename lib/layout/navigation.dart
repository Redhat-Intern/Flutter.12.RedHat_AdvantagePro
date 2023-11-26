import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Utilities/theme/size_data.dart';
import '../providers/drawer_provider.dart';

import '../pages/forum.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import 'sidebar.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = ref.read(DrawerKeyNotifier);
  }

  List<Widget> WidgetList = [
    Home(),
    Profile(),
    Forum(),
  ];
  List<Map<IconData, String>> iconNameList = [
    {Icons.home_outlined: "Home"},
    {Icons.person_outline_rounded: "Profile"},
    {Icons.forest_outlined: "Forum"},
  ];

  int index = 0;

  void indexShifter(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: IndexedStack(
            children: WidgetList,
            index: index,
          ),
        ),
      ),
      drawer: SideBar(
        iconNameList: iconNameList,
        index: index,
        indexShifter: indexShifter,
      ),
      drawerScrimColor: Colors.white.withOpacity(.3),
    );
  }
}
