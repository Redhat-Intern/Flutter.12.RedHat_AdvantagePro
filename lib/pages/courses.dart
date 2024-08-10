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
  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtr.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Column(children: [
      const PageHeader(tittle: "CERTIFICATES", isMenuButton: true),
      SizedBox(
        height: height * 0.02,
      ),

      //   Add course
      GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddCertification())),
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

      // Course List

      Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: "Courses",
          size: sizeData.subHeader,
          color: colorData.fontColor(.8),
          weight: FontWeight.w600,
        ),
      ),

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
              height: .75),
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

      // List of Courses

      Expanded(
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("courses").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> courseList =
                    snapshot.data!.docs.map((value) => value.data()).toList();

                if (searchCtr.text.isNotEmpty) {
                  courseList = courseList
                      .where((data) => data["name"]
                          .toString()
                          .toLowerCase()
                          .startsWith(searchCtr.text.trim().toLowerCase()))
                      .toList();
                }

                return courseList.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: height * 0.04),
                          Image.asset(
                            "assets/icons/PNF1.png",
                            width: width * .7,
                          ),
                          SizedBox(height: height * 0.04),
                          const CustomText(text: "NO DATA FOUND"),
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.01, horizontal: width * 0.01),
                        itemCount: courseList.length,
                        itemBuilder: (context, index) {
                          //
                          //
                          return GestureDetector(
                            onTap: () {
                              ref.read(courseDataProvider.notifier).clearData();
                              CourseService(ref: ref).readCourseData(
                                  courseName: courseList[index]["name"],
                                  isFromBatch: false);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CourseDetailPage(),
                                ),
                              ).then((_) {
                                ref
                                    .read(courseDataProvider.notifier)
                                    .clearData();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: height * 0.02,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: width * 0.015,
                                  horizontal: width * 0.015),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorData.secondaryColor(.2),
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  color: colorData.secondaryColor(.1)),
                              child: Row(
                                children: [
                                  CustomNetworkImage(
                                    size: height * .12,
                                    radius: 8,
                                    url: courseList[index]["image"],
                                    rightMargin: sizeData.width * 0.03,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
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
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
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
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          );
                        });
              } else {
                return const SizedBox();
              }
            }),
      ),
    ]);
  }
}
