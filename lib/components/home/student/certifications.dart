import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../common/text.dart';
import 'certifications_place_holder.dart';

class Certifications extends ConsumerStatefulWidget {
  const Certifications({
    super.key,
  });

  @override
  ConsumerState<Certifications> createState() => _CertificationsState();
}

class _CertificationsState extends ConsumerState<Certifications> {
  List<Map<String, Map<String, dynamic>>> certificationsList = [];
  final ScrollController _controller = ScrollController();

  int firstIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("students")
            .doc(ref.watch(userDataProvider)["email"])
            .collection("certifications").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
          // List<Map<String,dynamic>> certificationData = snapshot.data!.docs.map((e){
          //   var data =  Map.fromEntries(e.data().entries);
          //   data.addAll({"batchName": , "certificateName": })
          // }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              CustomText(
                text: "Certifications",
                size: sizeData.subHeader,
                color: colorData.fontColor(.8),
                weight: FontWeight.w800,
              ),

              SizedBox(
                height: height * 0.0125,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: height * 0.015,
                  bottom: height * 0.01,
                  left: width * 0.02,
                ),
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.04,
                            ),
                            Container(
                              height: aspectRatio * 15,
                              width: aspectRatio * 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorData.primaryColor(1),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            CustomText(
                              text: "",
                              size: sizeData.regular,
                              color: colorData.fontColor(.7),
                            ),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            CustomText(
                              text: "REG ID:",
                              size: sizeData.small,
                              color: colorData.fontColor(.6),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            CustomText(
                              text: "",
                              size: sizeData.regular,
                              color: colorData.fontColor(.8),
                              weight: FontWeight.bold,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    SizedBox(
                      height: height * 0.15,
                      child: ListView.builder(
                        controller: _controller,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.01,
                        ),
                        itemCount: certificationsList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          bool isFirst = certificationsList[index]
                                      ["status"]
                                  .toString() ==
                              "completed";
                          return Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            padding: EdgeInsets.all(isFirst ? 3 : 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isFirst
                                      ? colorData.primaryColor(.6)
                                      : Colors.transparent,
                                  width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                certificationsList[index].keys.first,
                                width: width * 0.25,
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: colorData.backgroundColor(.1),
                                      highlightColor:
                                          colorData.secondaryColor(.1),
                                      child: Container(
                                        width: width * 0.25,
                                        decoration: BoxDecoration(
                                          color: colorData.secondaryColor(.5),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
          }else{
            return CertificationsPlaceHolder();
          }
        });
  }
}
