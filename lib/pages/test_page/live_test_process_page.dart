// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../utilities/theme/color_data.dart';
// import '../../utilities/theme/size_data.dart';

// import '../../components/common/back_button.dart';
// import '../../components/common/text.dart';
// import '../../components/common/text_list.dart';

// class LiveTestProcessPage extends ConsumerStatefulWidget {
//   const LiveTestProcessPage(
//       {super.key,
//       required this.batchData,
//       required this.dayIndex,
//       required this.day});
//   final int dayIndex;
//   final String day;
//   final Map<String, dynamic> batchData;

//   @override
//   ConsumerState<LiveTestProcessPage> createState() => _LiveTestProcessPageState();
// }

// class _LiveTestProcessPageState extends ConsumerState<LiveTestProcessPage> {

//   @override
//   Widget build(BuildContext context) {
//     CustomSizeData sizeData = CustomSizeData.from(context);

//     CustomColorData colorData = CustomColorData.from(ref);

//     double height = sizeData.height;
//     double width = sizeData.width;
//     // double aspectRatio = sizeData.aspectRatio;

//     Row headerList = Row(
//       children: [
//         CustomBackButton(),
//         const Spacer(
//           flex: 2,
//         ),
//         CustomText(
//           text: "LIVE TEST",
//           size: sizeData.header,
//           color: colorData.fontColor(1),
//           weight: FontWeight.w600,
//         ),
//         const Spacer(),
//         CustomText(
//           text: widget.day,
//           size: sizeData.medium,
//           color: colorData.fontColor(.6),
//           weight: FontWeight.w800,
//         ),
//         SizedBox(
//           width: width * 0.02,
//         ),
//       ],
//     );

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           margin: EdgeInsets.only(
//             left: width * 0.04,
//             right: width * 0.04,
//             top: height * 0.02,
//           ),
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('liveTest')
//                 .doc(widget.batchData["name"])
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               Map<String, dynamic> snapshotData = snapshot.data!.data()!;
//               Map<String, dynamic> students =
//                   snapshotData[widget.dayIndex.toString()]["students"] != null
//                       ? Map.from(
//                           snapshotData[widget.dayIndex.toString()]["students"])
//                       : {};
//               int studentsToJoin =
//                   List.from(widget.batchData["students"]).length -
//                       students.length;

//               return Column(
//                 children: initiated
//                     ? [
//                         headerList,
//                         SizedBox(
//                           height: height * 0.03,
//                         ),
//                         Row(
//                           children: [
//                             CustomText(
//                               text: "Joint Students",
//                               weight: FontWeight.w700,
//                               color: colorData.fontColor(.7),
//                             ),
//                             const Spacer(),
//                             studentsToJoin > 0
//                                 ? CustomText(
//                                     text: "$studentsToJoin",
//                                     weight: FontWeight.w800,
//                                     size: sizeData.medium,
//                                     color: Colors.red,
//                                   )
//                                 : const SizedBox(),
//                             SizedBox(
//                               width: width * 0.02,
//                             ),
//                             CustomText(
//                               text: studentsToJoin > 0
//                                   ? "Have to join"
//                                   : "ALL ENTERED",
//                               color: studentsToJoin > 0
//                                   ? Colors.red.shade200
//                                   : Colors.green,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),
//                         CustomListText(
//                           data: students.values.map((e) => e["name"]).toList(),
//                           todo: null,
//                           placeholder:
//                               "No students have joined the test till NOW!",
//                           getChild: (index) => students.values
//                               .map((e) => e["name"])
//                               .toList()[index],
//                         ),
//                         SizedBox(
//                           height: height * 0.02,
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: GestureDetector(
//                             onTap: () {
//                               if (students.isNotEmpty) {
//                                 initiateTest(todo: "start");
//                               } else {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(const SnackBar(
//                                   content: Center(
//                                     child: CustomText(
//                                       text:
//                                           "Wait till the students join the test!",
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ));
//                               }
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: width * 0.04,
//                                 vertical: height * 0.01,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: colorData.secondaryColor(.5),
//                               ),
//                               child: const CustomText(
//                                 text: "START THE TEST",
//                                 weight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.02,
//                         ),
//                       ]
//                     : [
//                         headerList,
//                         SizedBox(
//                           height: height * 0.06,
//                         ),
//                         Align(
//                           alignment: Alignment.center,
//                           child: GestureDetector(
//                             onTap: () {
//                               initiateTest(todo: "created");
//                               setState(() {
//                                 initiated = true;
//                               });
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: width * 0.04,
//                                 vertical: height * 0.01,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: colorData.secondaryColor(.5),
//                               ),
//                               child: const CustomText(
//                                 text: "INTIATE THE TEST",
//                                 weight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.04,
//                         ),
//                         Image.asset(
//                           "assets/images/start_test.png",
//                           width: width,
//                           fit: BoxFit.fitWidth,
//                         ),
//                       ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
