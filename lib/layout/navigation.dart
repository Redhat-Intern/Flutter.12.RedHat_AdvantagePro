import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redhat_v1/layout/user_notfound.dart';
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

class _NavigationState extends ConsumerState<Navigation> {
  bool canPop = false;
  int index = 0;

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
