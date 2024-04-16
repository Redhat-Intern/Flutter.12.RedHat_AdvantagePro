import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/forum_category_provider.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

import '../common/icon.dart';
import '../common/text.dart';
import 'category_selection.dart';
import 'triangle_painter.dart';

class ForumHeader extends ConsumerStatefulWidget {
  const ForumHeader({
    super.key,
  });

  @override
  ConsumerState<ForumHeader> createState() => _ForumHeaderState();
}

class _ForumHeaderState extends ConsumerState<ForumHeader> {
  bool showCategorySelection = false;
  bool showSearch = false;
  TextEditingController controller = TextEditingController();
  double opacity = 0.0;
  double begin = 0.0;
  double end = 1.0;
  searchDataFun() {}

  void toggleShowCategorySelection() {
    setState(() {
      showCategorySelection = !showCategorySelection;
      showSearch = false;
    });
  }

  void toggleShowSearch() {
    setState(() {
      showCategorySelection = false;
      showSearch = !showSearch;
      if (showSearch) {
        begin = 0.0;
        end = 1.0;
      } else if (showSearch == false) {
        begin = 1.0;
        end = 0.0;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ForumCategory category = ref.watch(forumCategoryProvider);
    UserRole userRole = ref.watch(userRoleProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              userRole == UserRole.admin
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorData.primaryColor(.3),
                              colorData.primaryColor(1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIcon(
                            size: aspectRatio * 40,
                            icon: Icons.create_new_folder_rounded,
                            color: Colors.white.withOpacity(.9),
                          ),
                          SizedBox(
                            width: width * .02,
                          ),
                          CustomText(
                            text: "New Group",
                            size: sizeData.regular,
                            weight: FontWeight.w800,
                            color: Colors.white.withOpacity(.9),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const Spacer(),
              CustomText(
                text: category.name.toUpperCase(),
                color: colorData.fontColor(.6),
                weight: FontWeight.w800,
              ),
              GestureDetector(
                onTap: () => toggleShowCategorySelection(),
                child: Container(
                  padding: EdgeInsets.all(aspectRatio * 16),
                  margin: EdgeInsets.only(left: width * 0.04),
                  decoration: BoxDecoration(
                    color: colorData.secondaryColor(.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIcon(
                    icon: Icons.category_rounded,
                    color: colorData.fontColor(.6),
                    size: aspectRatio * 40,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  toggleShowSearch();
                },
                child: Container(
                  padding: EdgeInsets.all(aspectRatio * 16),
                  margin: EdgeInsets.only(left: width * 0.04),
                  decoration: BoxDecoration(
                    color: colorData.secondaryColor(.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIcon(
                    icon: Icons.search_rounded,
                    color: colorData.fontColor(.6),
                    size: aspectRatio * 40,
                  ),
                ),
              ),
            ],
          ),
          showCategorySelection
              ? Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.0125,
                        horizontal: width * 0.01,
                      ),
                      margin: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colorData.secondaryColor(.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CategorySelection(
                            category: ForumCategory.all,
                            icon: Icons.all_inbox_rounded,
                            onDone: toggleShowCategorySelection,
                          ),
                          CategorySelection(
                            category: ForumCategory.groups,
                            icon: Icons.groups_2_rounded,
                            onDone: toggleShowCategorySelection,
                          ),
                          CategorySelection(
                            category: ForumCategory.staffs,
                            icon: Icons.school_rounded,
                            onDone: toggleShowCategorySelection,
                          ),
                          userRole != UserRole.student
                              ? CategorySelection(
                                  category: ForumCategory.students,
                                  icon: Icons.person_rounded,
                                  onDone: toggleShowCategorySelection,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: height * 0.005,
                      right: width * 0.15,
                      child: CustomPaint(
                        size: Size(width * .05, height * .015),
                        painter: TrianglePainter(
                            color: colorData.secondaryColor(.4)),
                      ),
                    )
                  ],
                )
              : SizedBox(),
          showSearch
              ? TweenAnimationBuilder(
                  tween: Tween<double>(begin: begin, end: end),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Container(
                      height: height * 0.05 * value,
                      width: width,
                      margin: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.02,
                          right: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorData.secondaryColor(.3),
                      ),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (value) {
                          controller.clear();
                          // searchResult.clear();
                          toggleShowSearch();
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            searchDataFun();
                          } else {
                            setState(() {
                              controller.clear();
                              // searchResult.clear();
                            });
                          }
                        },
                        scrollPadding: EdgeInsets.zero,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: aspectRatio * 33,
                          color: colorData.fontColor(.8),
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search using Name or ID",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeData.medium * value,
                            color: colorData.fontColor(.5),
                            height: 1,
                          ),
                          contentPadding: EdgeInsets.only(
                            top: height * 0.008,
                          ),
                          border: InputBorder.none,
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if (controller.text.isNotEmpty) searchDataFun();
                            },
                            child: CustomIcon(
                              icon: Icons.search_rounded,
                              color: colorData.fontColor(.8),
                              size: aspectRatio * 50 * (value),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
