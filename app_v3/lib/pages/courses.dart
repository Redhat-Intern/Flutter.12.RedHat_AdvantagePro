import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/page_header.dart';
import '../components/common/text.dart';
import '../functions/read/course_data.dart';
import '../providers/course_data_provider.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import 'add_pages/add_course.dart';
import 'details/certificate_detail.dart';

class Courses extends ConsumerStatefulWidget {
  const Courses({super.key});

  @override
  ConsumerState<Courses> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  // Controller for the search field
  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adding a listener to the search controller to rebuild the UI on text change
    searchCtr.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // Dispose of the search controller to avoid memory leaks
    searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get size and color data for responsive design
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        // Page header with a title and a menu button
        const PageHeader(tittle: "courses", isMenuButton: true),
        SizedBox(height: height * 0.02),

        // Button to navigate to the 'Add Course' page
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourse()),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: height * 0.03),
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
              horizontal: width * 0.1,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorData.primaryColor(.6),
                  colorData.primaryColor(1),
                ],
              ),
            ),
            child: CustomText(
              text: "Add Course",
              size: sizeData.medium,
              color: colorData.secondaryColor(1),
              weight: FontWeight.w800,
            ),
          ),
        ),

        // Title for the course list section
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: "Courses",
            size: sizeData.subHeader,
            color: colorData.fontColor(.8),
            weight: FontWeight.w600,
          ),
        ),

        // Search field to filter courses
        Container(
          height: height * 0.045,
          margin: EdgeInsets.only(top: height * .015, bottom: height * .02),
          padding: EdgeInsets.only(
            top: height * 0.008,
            bottom: height * 0.008,
            left: width * 0.04,
            right: width * 0.01,
          ),
          decoration: BoxDecoration(
            color: colorData.secondaryColor(.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: searchCtr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: aspectRatio * 33,
              color: colorData.fontColor(.8),
              height: .75,
            ),
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                bottom: height * 0.02,
              ),
              hintText: "Search for course",
              hintStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: sizeData.medium,
                color: colorData.fontColor(.5),
              ),
              border: InputBorder.none,
              suffixIcon: CustomIcon(
                icon: Icons.search_rounded,
                color: colorData.fontColor(.6),
                size: aspectRatio * 50,
              ),
            ),
          ),
        ),

        // StreamBuilder to listen for real-time updates from Firestore
        Expanded(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("courses").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Convert Firestore documents to a list of course data
                List<Map<String, dynamic>> courseList =
                    snapshot.data!.docs.map((value) => value.data()).toList();

                // Filter courses based on the search input
                if (searchCtr.text.isNotEmpty) {
                  courseList = courseList
                      .where((data) => data["name"]
                          .toString()
                          .toLowerCase()
                          .startsWith(searchCtr.text.trim().toLowerCase()))
                      .toList();
                }

                // Show a placeholder if no courses are found
                if (courseList.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: height * 0.04),
                      Image.asset(
                        "assets/icons/PNF1.png",
                        width: width * .7,
                      ),
                      SizedBox(height: height * 0.04),
                      const CustomText(text: "NO DATA FOUND"),
                    ],
                  );
                }

                // Display the list of courses
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.01, horizontal: width * 0.01),
                  itemCount: courseList.length,
                  itemBuilder: (context, index) {
                    // Course item UI
                    return GestureDetector(
                      onTap: () {
                        // Clear and read course data for the selected course
                        ref.read(courseDataProvider.notifier).clearData();
                        ref.read(courseServiceProvider).readCourseData(
                              courseName: courseList[index]["name"],
                              isFromBatch: false,
                            );

                        // Navigate to the course detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CourseDetailPage(),
                          ),
                        ).then((_) {
                          // Clear course data when returning from detail page
                          ref.read(courseDataProvider.notifier).clearData();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        padding: EdgeInsets.symmetric(
                            vertical: width * 0.015, horizontal: width * 0.015),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorData.secondaryColor(.2),
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          color: colorData.secondaryColor(.1),
                        ),
                        child: Row(
                          children: [
                            // Course image
                            CustomNetworkImage(
                              size: height * .12,
                              radius: 8,
                              url: courseList[index]["image"],
                              rightMargin: sizeData.width * 0.03,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Course name
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Name: ",
                                          style: TextStyle(
                                            fontSize: sizeData.small,
                                            color: colorData.fontColor(.6),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: courseList[index]["name"],
                                          style: TextStyle(
                                            fontSize: sizeData.medium,
                                            color: colorData.fontColor(.9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  // Course description
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Description: ",
                                          style: TextStyle(
                                            fontSize: sizeData.small,
                                            color: colorData.fontColor(.6),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: courseList[index]
                                              ["description"],
                                          style: TextStyle(
                                            fontSize: sizeData.medium,
                                            color: colorData.fontColor(.9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  // Course days
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Course Days: ",
                                          style: TextStyle(
                                            fontSize: sizeData.small,
                                            color: colorData.fontColor(.6),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: Map.from(courseList[index]
                                                  ["courseContent"])
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: sizeData.medium,
                                            color: colorData.fontColor(.9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Show an empty container while data is loading
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
