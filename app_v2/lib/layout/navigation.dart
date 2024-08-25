import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../model/user.dart';
import '../pages/courses.dart';
import '../pages/home/admin_home.dart';
import '../pages/home/staff_home.dart';
import '../pages/home/student_home.dart';
import '../providers/applifecycle_state.dart';
import '../providers/user_detail_provider.dart';
import '../utilities/console_logger.dart';
import '../utilities/routes.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import '../pages/report.dart';
import '../providers/drawer_provider.dart';

import '../pages/forum.dart';
import 'sidebar.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key, required this.index});
  final int index;

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation>
    with WidgetsBindingObserver {
  late GlobalKey<ScaffoldState> scaffoldKey;
  bool canPop = false;
  int index = 0;
  @override
  void initState() {
    super.initState();
    index = widget.index;
    scaffoldKey = ref.read(drawerKeyProvider);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppStateNotifier appStateNotifier =
        ref.read(appLifecycleStateProvider.notifier);

    switch (state) {
      case AppLifecycleState.resumed:
        appStateNotifier.setAppState(lifecycle: AppLifecycleState.resumed);
        ConsoleLogger.message("App is in the foreground (resumed)");
        break;
      case AppLifecycleState.inactive:
        appStateNotifier.setAppState(lifecycle: AppLifecycleState.inactive);
        ConsoleLogger.message("App is inactive");
        break;
      case AppLifecycleState.paused:
        appStateNotifier.setAppState(lifecycle: AppLifecycleState.paused);
        ConsoleLogger.message("App is in the background (paused)");
        break;
      case AppLifecycleState.detached:
        appStateNotifier.setAppState(lifecycle: AppLifecycleState.detached);
        ConsoleLogger.message("App is detached");
        break;
      case AppLifecycleState.hidden:
        appStateNotifier.setAppState(lifecycle: AppLifecycleState.hidden);
        ConsoleLogger.message("App is hidden");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navigation
    UserModel userData = ref.watch(userDataProvider);

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    ref.listen(appLifecycleStateProvider, (prev, next) {
      FirebaseFirestore.instance.collection("forum").doc("status").set({
        userData.userRole == UserRole.superAdmin ? "admin" : userData.email:
            next == AppLifecycleState.resumed
      }, SetOptions(merge: true));
    });

    List<Widget> widgetList = [];
    List<Map<IconData, String>> iconNameList = [];

    if (userData.userRole == UserRole.superAdmin ||
        userData.userRole == UserRole.admin) {
      widgetList = [
        const AdminHome(),
        const Forum(),
        const Report(),
        const Courses(),
      ];
      iconNameList = [
        {Symbols.home_app_logo_rounded: "Home"},
        {Symbols.forum_rounded: "Forum"},
        {Symbols.crisis_alert_rounded: "Report"},
        {Symbols.developer_guide_rounded: "Courses"},
      ];
    } else if (userData.userRole == UserRole.staff) {
      widgetList = [
        const StaffHome(),
        const Forum(),
      ];
      iconNameList = [
        {Symbols.home_app_logo_rounded: "Home"},
        {Symbols.forum_rounded: "Forum"},
      ];
    } else if (userData.userRole == UserRole.student) {
      widgetList = [
        const StudentHome(),
        const Forum(),
      ];
      iconNameList = [
        {Symbols.home_app_logo_rounded: "Home"},
        {Symbols.forum_rounded: "Forum"},
      ];
    }

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
          child: PopScope(
            canPop: index == 0,
            onPopInvoked: (didPop) {
              if (didPop) {
                exit(1);
              } else {
                GoRouter.of(context).goNamed(Routes.homeName);
              }
            },
            child: IndexedStack(
              index: index,
              children: widgetList,
            ),
          ),
        ),
      ),
      drawer: SideBar(
        iconNameList: iconNameList,
        index: index,
      ),
      drawerScrimColor: colorData.secondaryColor(.4),
    );
  }
}
