import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../components/common/icon.dart';
import '../../components/common/page_header.dart';
import '../../components/common/waiting_widgets/course_waiting.dart';
import '../../components/home/student/course_files.dart';
import '../../model/course.dart';
import '../../providers/course_data_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/add_course/course_pdf_picker.dart';
import '../../components/add_course/course_content_textfield.dart';
import '../../components/add_course/details_inputfield.dart';
import '../../components/common/text.dart';

class CourseDetailPage extends ConsumerStatefulWidget {
  const CourseDetailPage({super.key});

  @override
  ConsumerState<CourseDetailPage> createState() => AddCourseState();
}

class AddCourseState extends ConsumerState<CourseDetailPage> {
  int firstIndex = 0;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    CourseData courseData = ref.watch(courseDataProvider);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: !courseData.isEmpty()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageHeader(
                      tittle: "course",
                      isMenuButton: false,
                      secondaryWidget: GestureDetector(
                        onTap: () {
                          ref.read(courseDataProvider.notifier).deleteCourse();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: height * .005, left: width * 0.05),
                          padding: EdgeInsets.only(
                            left: width * 0.01,
                            right: width * 0.02,
                            top: height * 0.005,
                            bottom: height * 0.005,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorData.secondaryColor(.3),
                          ),
                          child: Row(
                            children: [
                              CustomIcon(
                                size: aspectRatio * 45,
                                icon: Icons.close_rounded,
                                color: Colors.red,
                              ),
                              CustomText(
                                text: "DELETE",
                                size: sizeData.regular,
                                color: Colors.red,
                                weight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .03,
                    ),
                    CourseDetail(
                      discription: TextEditingController(
                          text: courseData.description),
                      name: TextEditingController(text: courseData.name),
                      from: From.detail,
                      imageURL: courseData.imageURL,
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    CoursePDF(
                      from: From.detail,
                      file: courseData.coursePDF,
                    ),
                    SizedBox(
                      height: height * .04,
                    ),
                    courseData.courseDataList.isEmpty
                        ? CourseContentWaitingWidget(
                            count: courseData.courseDataLength,
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "Course content",
                                  size: sizeData.medium,
                                  color: colorData.fontColor(.8),
                                  weight: FontWeight.w800,
                                ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                Container(
                                  height: height * 0.06,
                                  padding: EdgeInsets.only(
                                    left: width * 0.03,
                                    top: height * 0.006,
                                    bottom: height * 0.006,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorData.secondaryColor(.15),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.005,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: courseData.courseDataLength,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          firstIndex = index;
                                        }),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: width * 0.03),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02,
                                            vertical: height * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: colorData.secondaryColor(
                                                firstIndex == index ? .4 : .3),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Day $index",
                                              size: sizeData.regular,
                                              color: firstIndex == index
                                                  ? colorData.primaryColor(.8)
                                                  : colorData.fontColor(.4),
                                              weight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorData.secondaryColor(.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        CourseContentInputField(
                                          header: "Title: ",
                                          from: From.detail,
                                          text: courseData
                                                  .courseDataList.isNotEmpty
                                              ? courseData
                                                  .courseDataList[firstIndex]
                                                  .title
                                              : null,
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        CourseContentInputField(
                                          header: "Topics: ",
                                          from: From.detail,
                                          text: courseData
                                                  .courseDataList.isNotEmpty
                                              ? courseData
                                                  .courseDataList[firstIndex]
                                                  .topics
                                              : null,
                                        ),
                                        //
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        CourseFiles(
                                            courseFiles: courseData
                                                .courseDataList[firstIndex]
                                                .files),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: height * .02,
                    ),
                  ],
                )
              : SizedBox(
                  height: height,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/json/sending.json",
                        width: width * .7,
                      ),
                      Lottie.asset(
                        "assets/json/loadingProgress.json",
                        width: width * .5,
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      SizedBox(
                        width: width * .7,
                        child: CustomText(
                          text: "Fetching the Data",
                          size: sizeData.medium,
                          color: colorData.primaryColor(1),
                          weight: FontWeight.w600,
                          maxLine: 3,
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
