import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/pages/add_certification.dart';

import '../utilities/theme/size_data.dart';
import '../pages/report.dart';
import '../providers/navigation_index_provider.dart';
import '../providers/drawer_provider.dart';

import '../pages/forum.dart';
import '../pages/home.dart';
import 'sidebar.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  bool canPop = false;
  late GlobalKey<ScaffoldState> scaffoldKey;
  int index = 0;

  @override
  void initState() {
    super.initState();
    scaffoldKey = ref.read(drawerKeyProvider);
  }

  List<Widget> WidgetList = [
    const Home(),
    const Report(),
    const Forum(),
    const AddCertification(),
  ];
  List<Map<IconData, String>> iconNameList = [
    {Icons.home_outlined: "Home"},
    {Icons.report: "Report"},
    {Icons.forest_outlined: "Forum"},
    {Icons.add_moderator_rounded: "Certification"},
  ];

  popFunction(WidgetRef ref) async {
    if (ref.read(navigationIndexProvider) == 0) {
      return true;
    } else {
      ref.read(navigationIndexProvider.notifier).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    index = ref.watch(navigationIndexProvider);
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: WillPopScope(
            onWillPop: () => popFunction(ref),
            child: IndexedStack(
              index: index,
              children: WidgetList,
            ),
          ),
        ),
      ),
      drawer: SideBar(
        iconNameList: iconNameList,
      ),
      drawerScrimColor: Colors.white.withOpacity(.3),
    );
  }
}
