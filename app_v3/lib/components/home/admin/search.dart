import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/static_data.dart';
import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';
import '../../common/text.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  TextEditingController searchCtr = TextEditingController();
  String selectedItem = "batches";
  Map<String, String> searchResult = {};

  void searchDataFun() async {
    var searchString = searchCtr.text.toUpperCase();
    if (selectedItem == "batches") {
      var document = await FirebaseFirestore.instance
          .collection(selectedItem)
          .doc(searchString)
          .get();

      if (document.exists) {
        var data = document.data();
        setState(() {
          searchResult = {
            "header": data!["name"],
            "value": "Started At: ${data["time"]}"
          };
        });
      } else {
        setState(() {
          searchResult = {"error": "Batch ID not matched"};
        });
      }
    } else if (selectedItem == "staffs") {
      var document = await FirebaseFirestore.instance.collection("users").get();

      var dataSnapShot = document.docs.where((value) =>
          value.data()["id"].toString().toUpperCase() ==
          searchString.toUpperCase());
      setState(() {
        if (dataSnapShot.isNotEmpty) {
          var data = dataSnapShot.first.data();
          searchResult = {
            "header": data["name"],
            "value":
                "${data["userRole"] == "admin" ? "Admin Staff" : "Staff"} with ID: ${searchString.toUpperCase()}"
          };
        } else {
          searchResult = {"error": "Staff ID not found"};
        }
      });
    } else if (selectedItem == "students") {
      var document =
          await FirebaseFirestore.instance.collection(selectedItem).get();

      var dataSnapShot = document.docs.where(
          (value) => Map.from(value.data()["id"]).containsKey(searchString));
      setState(() {
        if (dataSnapShot.isNotEmpty) {
          var data = dataSnapShot.first.data();
          searchResult = {
            "header": data["name"],
            "value":
                "Currently learning in the batch ${data["currentBatch"].keys.first}"
          };
        } else {
          searchResult = {"error": "Student ID not found"};
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header text
        CustomText(
          text: "Search for Batch, Student or Staff",
          size: sizeData.regular,
          color: colorData.fontColor(.6),
          weight: FontWeight.w600,
        ),
        SizedBox(
          height: height * 0.02,
        ),

        // Search Field
        Container(
          height: height * 0.045,
          padding: EdgeInsets.only(
            top: height * 0.005,
            bottom: height * 0.005,
            left: width * 0.015,
            right: width * 0.01,
          ),
          decoration: BoxDecoration(
            color: colorData.secondaryColor(.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: height * 0.035,
                padding: EdgeInsets.only(left: width * 0.02),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  underline: const SizedBox(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sizeData.regular,
                    color: colorData.fontColor(.8),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  elevation: 0,
                  alignment: Alignment.center,
                  hint: CustomText(
                    text: selectedItem.toString()[0].toUpperCase() +
                        selectedItem.toString().substring(1),
                    size: sizeData.medium,
                    color: colorData.fontColor(.7),
                    weight: FontWeight.w600,
                  ),
                  items: searchData
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: CustomText(
                            text: e.toString()[0].toUpperCase() +
                                e.toString().substring(1),
                            size: sizeData.regular,
                            color: colorData.fontColor(.8),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value.toString();
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  height: height * 0.045,
                  margin: EdgeInsets.only(left: width * 0.03),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: searchCtr,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        searchDataFun();
                      } else {
                        setState(() {
                          searchCtr.clear();
                          searchResult.clear();
                        });
                      }
                    },
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
                      hintText: "Enter the ID",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeData.medium,
                        color: colorData.fontColor(.5),
                      ),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (searchCtr.text.isNotEmpty) searchDataFun();
                        },
                        child: CustomIcon(
                          icon: Icons.search_rounded,
                          color: colorData.fontColor(.6),
                          size: aspectRatio * 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Searched Data
        searchResult.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    if (searchResult.length == 1) {
                      searchResult.clear();
                      searchCtr.clear();
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.01),
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
                                    colorData.primaryColor(1),
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
            : const SizedBox(),
      ],
    );
  }
}
