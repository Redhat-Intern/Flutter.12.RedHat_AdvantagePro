import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/icon.dart';
import '../common/text.dart';
import 'batch_report_result.dart';
import '../../pages/details/detailed_batch_report.dart';

class BatchReport extends ConsumerStatefulWidget {
  const BatchReport({
    super.key,
  });

  @override
  ConsumerState<BatchReport> createState() => _BatchReport();
}

class _BatchReport extends ConsumerState<BatchReport> {
  TextEditingController controller = TextEditingController();
  Map<String, dynamic> searchResult = {};
  Map<String, dynamic> toShow = {};
  Map<String, dynamic> searchData = {};

  void searchDataFun() async {
    var searchString = controller.text.toUpperCase();
    var document = await FirebaseFirestore.instance
        .collection("batches")
        .doc(searchString)
        .get();

    if (document.exists) {
      var data = document.data();
      setState(() {
        searchResult = {
          "header": data!["name"],
          "value": "Started At: ${data["time"]}"
        };
        searchData = data;
        toShow = {
          "start": List.from(data["dates"]).first,
          "end": List.from(data["dates"]).last,
          "studentsLen": List.from(data["students"]).length,
          "completed": data["completed"],
          "certifiedStudents": null,
          "centumCount": null,
        };
      });
    } else {
      setState(() {
        searchResult = {"error": "Batch ID not matched"};
        searchData.clear();
        toShow.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "BatchReport",
            size: sizeData.subHeader,
            weight: FontWeight.w800,
            color: colorData.fontColor(.8),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            height: height * 0.05,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorData.secondaryColor(.3),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchDataFun();
                } else {
                  setState(() {
                    controller.clear();
                    searchResult.clear();
                    toShow.clear();
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
                hintText: "Enter the Batch ID",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeData.medium,
                  color: colorData.fontColor(.5),
                  height: 1,
                ),
                border: InputBorder.none,
                prefixIcon: GestureDetector(
                  onTap: () {
                    if (controller.text.isNotEmpty) searchDataFun();
                  },
                  child: CustomIcon(
                    icon: Icons.search_rounded,
                    color: colorData.fontColor(.8),
                    size: aspectRatio * 50,
                  ),
                ),
              ),
            ),
          ),

          // Searched Data
          searchResult.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    if (!(searchResult.keys.contains('error'))) {
                      setState(() {
                        if (searchResult.length == 1) {
                          searchResult.clear();
                          controller.clear();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailedBatchReport(searchData: searchData),
                          ),
                        );
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.01,
                      bottom: height * 0.01,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.01,
                      vertical: height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colorData.fontColor(.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        searchResult.length == 2
                            ? Container(
                                margin: EdgeInsets.only(right: width * 0.03),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorData.primaryColor(.2),
                                      colorData.primaryColor(1)
                                    ],
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.005,
                                ),
                                child: CustomText(
                                  text: searchResult["header"]!,
                                  size: sizeData.regular,
                                  color: colorData.secondaryColor(1),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.02, right: width * 0.1),
                                child: Image.asset(
                                  "assets/icons/SNF1.png",
                                  height: height * 0.06,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                        searchResult.length == 2
                            ? CustomText(
                                text: searchResult["value"]!,
                                color: colorData.fontColor(.5),
                                size: aspectRatio * 28,
                                weight: FontWeight.bold,
                              )
                            : CustomText(
                                text: searchResult["error"]!,
                                color: Colors.red,
                                size: aspectRatio * 28,
                                weight: FontWeight.bold,
                              ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: height * 0.02,
                ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.01,
              ),
              alignment: Alignment.center,
              child: toShow.isNotEmpty
                  ? Column(
                      children: [
                        BatchReportResult(
                            header: "Start Date:", value: toShow["start"]),
                        BatchReportResult(
                            header: "End Date:", value: toShow["end"]),
                        BatchReportResult(
                            header: "Students Enrolled:",
                            value: toShow["studentsLen"].toString()),
                        const BatchReportResult(
                            header: "STATUS:", value: "LIVE"),
                        // BatchReportResult(header: "Centum Count:", value: "9"),
                      ],
                    )
                  : Column(
                      children: [
                        Image.asset(
                          "assets/icons/DNF3.png",
                          height: height * 0.225,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        const CustomText(
                            text: "Search for the batch using Bath ID")
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
