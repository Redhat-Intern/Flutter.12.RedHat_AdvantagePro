import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';

import '../../common/network_image.dart';
import '../../common/text.dart';
import '../../common/waiting_widgets/certification_waiting.dart';

class Certifications extends ConsumerStatefulWidget {
  const Certifications({
    super.key,
    required this.batchList,
  });
  final List<Map<String, dynamic>> batchList;

  @override
  ConsumerState<Certifications> createState() => _CertificationsState();
}

class _CertificationsState extends ConsumerState<Certifications> {
  List<Map<String, dynamic>> certificationsList = [];
  final ScrollController _controller = ScrollController();

  int firstIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.batchList.isNotEmpty) {
      for (var element in widget.batchList) {
        Map<String, dynamic> data = element;
        FirebaseFirestore.instance
            .collection("certificates")
            .doc(element["certificateID"])
            .get()
            .then((value) {
          setState(() {
            data.addAll(value.data()!);
            certificationsList.add(data);
          });
        });
      }
    }
  }

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

    return certificationsList.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                decoration: BoxDecoration(
                  color: colorData.secondaryColor(.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: SizedBox(
                  height: height * 0.185,
                  child: ListView.builder(
                    controller: _controller,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                    ),
                    itemCount: certificationsList.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      bool isFirst =
                          certificationsList[index]["completed"] ?? true;

                      return Column(
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          CustomText(
                              text: certificationsList[index]["name"],
                              weight: FontWeight.w800),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            padding: EdgeInsets.all(isFirst ? 3 : 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isFirst
                                    ? colorData.primaryColor(.6)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CustomNetworkImage(
                              size: height * .125,
                              radius: 8,
                              url: certificationsList[index]['image'],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          )
        : const CertificationWaitingWidget();
  }
}
