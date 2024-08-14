import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redhat_v1/layout/user_notfound.dart';
import 'package:redhat_v1/providers/applifecycle_state.dart';
import 'package:redhat_v1/utilities/console_logger.dart';

import '../components/common/shimmer_box.dart';
import '../components/common/waiting_widgets/header_waiting.dart';
import '../components/common/waiting_widgets/recent_waiting.dart';
import '../components/common/waiting_widgets/search_field_waiting.dart';
import '../components/common/waiting_widgets/staffs_list_waiting.dart';
import '../model/user.dart';
import '../pages/courses.dart';
import '../pages/home/admin_home.dart';
import '../pages/home/staff_home.dart';
import '../pages/home/student_home.dart';
import '../providers/user_detail_provider.dart';
import '../utilities/static_data.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import '../pages/report.dart';
import '../providers/navigation_index_provider.dart';
import '../providers/drawer_provider.dart';

import '../pages/forum.dart';
import 'sidebar.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation>
    with WidgetsBindingObserver {
  bool canPop = false;
  int index = 0;
  @override
  void initState() {
    super.initState();
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

  popFunction(WidgetRef ref) async {
    if (ref.read(navigationIndexProvider) == 0) {
      return exit(0);
    } else {
      ref.read(navigationIndexProvider.notifier).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navigation
    GlobalKey<ScaffoldState> scaffoldKey = ref.watch(drawerKeyProvider);
    index = ref.watch(navigationIndexProvider);

    MapEntry<UserModel, String?> userProviderData = ref.watch(userDataProvider);
    UserModel userData = userProviderData.key;

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double width = sizeData.width;
    double height = sizeData.height;

    ref.listen(appLifecycleStateProvider, (prev, next) {
      FirebaseFirestore.instance.collection("forum").doc("status").set(
          {userData.email: next == AppLifecycleState.resumed},
          SetOptions(merge: true));
    });

    List<Widget> widgetList = [];
    List<Widget> loadingList = [
      const MainPageHeaderWaitingWidget(),
      const SearchFieldWaitingWidget(),
      const RecentWaitingWidget(),
      const StaffsListWaiting(),
      ShimmerBox(height: height * 0.1, width: width * 0.45),
      const SizedBox(),
    ];
    List<Map<IconData, String>> iconNameList = [];

    if (userData.userRole == UserRole.superAdmin ||
        userData.userRole == UserRole.admin) {
      widgetList = [
        const AdminHome(),
        const Report(),
        const Forum(),
        const Courses(),
      ];
      iconNameList = [
        {Symbols.home_app_logo_rounded: "Home"},
        {Symbols.crisis_alert_rounded: "Report"},
        {Symbols.forum_rounded: "Forum"},
        {Symbols.developer_guide_rounded: "Certification"},
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

    if (userProviderData.value == null) {
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
            child: userData.userRole == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: loadingList)
                : PopScope(
                    canPop: ref.read(navigationIndexProvider) == 0,
                    onPopInvoked: (didPop) {
                      if (didPop) {
                        exit(1);
                      } else {
                        ref.read(navigationIndexProvider.notifier).jumpTo(0);
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
        ),
        drawerScrimColor: colorData.secondaryColor(.4),
      );
    } else {
      ConsoleLogger.message("I AM", from: "navigator");
      return const UserNotfound();
    }
  }
}
