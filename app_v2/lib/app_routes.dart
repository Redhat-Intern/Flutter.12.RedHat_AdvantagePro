import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/add_course/details_inputfield.dart';
import 'components/report/batch_report.dart';
import 'layout/auth.dart';
import 'layout/loading_page.dart';
import 'layout/navigation.dart';
import 'layout/obscreen.dart';
import 'layout/splash.dart';
import 'model/app_state.dart';
import 'model/user.dart';

import 'pages/add_pages/add_course.dart';
import 'pages/add_pages/add_staff.dart';
import 'pages/attendance_page.dart';
import 'pages/auth_pages/login.dart';
import 'pages/auth_pages/signup.dart';
import 'pages/batch/create_batch.dart';
import 'pages/batch/create_from_saved_batch.dart';
import 'pages/chatting_page.dart';
import 'pages/details/batch_detail.dart';
import 'pages/details/staff_detail.dart';
import 'pages/details/student_detail.dart';
import 'pages/maintenance/error_page.dart';
import 'pages/maintenance/no_internet.dart';
import 'pages/maintenance/under_maintenance.dart';
import 'pages/profile.dart';
import 'pages/show_all/batches.dart';
import 'pages/show_all/staffs.dart';
import 'providers/app_state_provider.dart';
import 'utilities/console_logger.dart';
import 'utilities/routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final AppState appState = ref.watch(appStateProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (context, state) {
      final currentLocation = state.fullPath;

      ConsoleLogger.route(
          "Path : ${state.path}, FullPath: ${state.fullPath}, URI: ${state.uri}, Name: ${state.name}");

      // Handle splash screen
      if (appState.splashPage) {
        return Routes.splash;
      }

      // Handle server maintenance
      if (appState.serverUnderMaintenance) {
        return Routes.underMaintenance;
      }

      // Handle errors
      if (appState.hasError) {
        return Routes.error; // Adjust this route based on your setup
      }

      // Handle no internet
      if (!appState.isConnected) {
        return Routes.noInternet;
      }

      // Handle loading
      if (appState.isLoading) {
        return Routes.loading;
      }

      // Handle first run (onboarding)
      if (appState.isFirstRun) {
        return Routes.onboarding;
      }

      // Handle user authentication
      if (!appState.userExists) {
        // Allow navigation within authentication pages
        if (currentLocation == Routes.mainAuth ||
            currentLocation == Routes.login ||
            currentLocation == Routes.signup) {
          return null;
        }
        // Redirect to mainAuth if user is not authenticated
        return Routes.mainAuth;
      }

      // Handle user removed case
      if (appState.isUserRemoved) {
        return Routes.userNotFound;
      }

      // Default authenticated user home route
      if (appState.userExists) {
        // Prevent redirect loop by checking if already on home
        if (currentLocation != Routes.home &&
            currentLocation == Routes.splash) {
          return Routes.home;
        }
        return null;
      }

      // Default behavior: no redirect
      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: Routes.splash,
        name: Routes.splashName,
        builder: (context, state) => const Splash(),
      ),

      // Onboarding
      GoRoute(
        path: Routes.onboarding,
        name: Routes.onboardingName,
        builder: (context, state) => const OBScreen(),
      ),

      // Loading
      GoRoute(
        path: Routes.loading,
        name: Routes.loadingName,
        builder: (context, state) => const LoadingPage(),
      ),

      // Main Authentication
      GoRoute(
        path: Routes.mainAuth,
        name: Routes.mainAuthName,
        builder: (context, state) => const MainAuthPage(),
      ),

      // Login
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (context, state) => const Login(),
      ),

      // Signup
      GoRoute(
        path: Routes.signup,
        name: Routes.signupName,
        builder: (context, state) => const Signup(),
      ),

      // Home
      GoRoute(
        path: Routes.home,
        name: Routes.homeName,
        builder: (context, state) => const Navigation(index: 0),
      ),

      // No Internet
      GoRoute(
        path: Routes.noInternet,
        name: Routes.noInternetName,
        builder: (context, state) => const NoInternet(),
      ),

      // Under Maintenance
      GoRoute(
        path: Routes.underMaintenance,
        name: Routes.underMaintenanceName,
        builder: (context, state) => const UnderMaintenance(),
      ),

      // Profile
      GoRoute(
        path: Routes.profile,
        name: Routes.profileName,
        builder: (context, state) => const Profile(),
      ),

      // Staff Management
      GoRoute(
        path: Routes.addStaff,
        name: Routes.addStaffName,
        builder: (context, state) => const AddStaff(),
      ),
      GoRoute(
        path: Routes.staffDetail,
        name: Routes.staffDetailName,
        builder: (context, state) {
          // Accessing the staffData
          final UserModel staffData = state.extra as UserModel;

          return StaffDetail(staff: staffData);
        },
      ),
      GoRoute(
        path: Routes.allStaffs,
        name: Routes.allStaffsName,
        builder: (context, state) => const AllStaffs(),
      ),

      // Batch Management
      GoRoute(
        path: Routes.allBatches,
        name: Routes.allBatchesName,
        builder: (context, state) => const AllBatches(),
      ),
      GoRoute(
        path: Routes.batchDetail,
        name: Routes.batchDetailName,
        builder: (context, state) {
          // Accessing the batchData
          final Map<String, dynamic> batchData =
              state.extra as Map<String, dynamic>;

          return BatchDetail(batchData: batchData);
        },
      ),
      GoRoute(
        path: Routes.createBatch,
        name: Routes.createBatchName,
        builder: (context, state) => const CreateBatch(),
      ),
      GoRoute(
        path: Routes.createFromSavedBatch,
        name: Routes.createFromSavedBatchName,
        builder: (context, state) {
          // Accessing the batchData
          final Map<String, dynamic> batchData =
              state.extra as Map<String, dynamic>;

          return CreateFromSavedBatch(
            courseID: batchData['courseID'],
            name: batchData['name'],
            selectDates: batchData['selectedDates'],
            staffID: batchData['staffID'],
          );
        },
      ),

      // Courses
      GoRoute(
        path: Routes.courses,
        name: Routes.coursesName,
        builder: (context, state) => const Navigation(index: 3),
      ),
      GoRoute(
        path: Routes.addCourse,
        name: Routes.addCourseName,
        builder: (context, state) => const AddCourse(),
      ),
      GoRoute(
        path: Routes.courseDetail,
        name: Routes.courseDetailName,
        builder: (context, state) {
          // Accessing the courseData
          final Map<String, dynamic> courseData =
              state.extra as Map<String, dynamic>;

          return CourseDetail(
            discription: courseData['description'],
            from: courseData['from'],
            name: courseData['name'],
            imageSetter: courseData['imageSetter'],
            imageURL: courseData['imageURL'],
          );
        },
      ),

      // Forum
      GoRoute(
        path: Routes.forum,
        name: Routes.forumName,
        builder: (context, state) => const Navigation(index: 1),
      ),
      GoRoute(
        path: Routes.forumChat,
        name: Routes.forumChatName,
        builder: (context, state) {
          // Accessing the index
          final int index = state.extra as int;

          return ChattingPage(index: index);
        },
      ),

      // Reports
      GoRoute(
        path: Routes.report,
        name: Routes.reportName,
        builder: (context, state) => const Navigation(index: 2),
      ),
      GoRoute(
        path: Routes.batchReport,
        name: Routes.batchReportName,
        builder: (context, state) => const BatchReport(),
      ),
      GoRoute(
        path: Routes.studentDetail,
        name: Routes.studentDetailName,
        builder: (context, state) => const StudentDetail(),
      ),
      // comming soon.

      // GoRoute(
      //   path: Routes.staffReport,
      //   name: Routes.staffReportName,
      //   builder: (context, state) => const StaffReport(),
      // ),

      // Attendance
      GoRoute(
        path: Routes.attendance,
        name: Routes.attendanceName,
        builder: (context, state) {
          // Accessing the attendanceData
          final Map<String, dynamic> attendanceData =
              state.extra as Map<String, dynamic>;

          return AttendancePage(
            day: attendanceData['day'],
            dayIndex: attendanceData['dayIndex'],
            docRef: attendanceData['docRef'],
            students: attendanceData['students'],
          );
        },
      ),

      // Test page Routes
      // GoRoute(
      //   path: Routes.createTest,
      //   name: Routes.createTestName,
      //   builder: (context, state) => const CreateTest(),
      // ),
      // GoRoute(
      //   path: Routes.liveTestAttender,
      //   name: Routes.liveTestAttenderName,
      //   builder: (context, state) => const LiveTestAttender(),
      // ),
      // GoRoute(
      //   path: Routes.dailyTestAttender,
      //   name: Routes.dailyTestAttenderName,
      //   builder: (context, state) => const DailyTestAttender(),
      // ),

      // Fallback route
      GoRoute(
        path: '/:path(.*)',
        builder: (context, state) => const ErrorPage(),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const ErrorPage(), // Define your ErrorPage widget here
    ),
  );
});
