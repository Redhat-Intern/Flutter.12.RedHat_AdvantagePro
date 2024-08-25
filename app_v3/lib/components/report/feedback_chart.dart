// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../utilities/theme/color_data.dart';
// import '../../utilities/theme/size_data.dart';

// class FeedbackChart extends ConsumerWidget {
//   const FeedbackChart({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     List<ChartData> chartData = [
//       ChartData(2010, 20),
//       ChartData(2011, 13),
//       ChartData(2012, 24),
//       ChartData(2013, 17),
//       ChartData(2014, 30)
//     ];

//     CustomSizeData sizeData = CustomSizeData.from(context);
//     CustomColorData colorData = CustomColorData.from(ref);

//     double height = sizeData.height;
//     double width = sizeData.width;

//     return Expanded(
//       child: SfCartesianChart(
//         margin: EdgeInsets.symmetric(
//           vertical: height * 0.015,
//           horizontal: width * 0.04,
//         ),
//         borderColor: Colors.transparent,
//         plotAreaBorderColor: Colors.transparent,
//         primaryXAxis: const CategoryAxis(isVisible: false),
//         primaryYAxis: const CategoryAxis(
//           isVisible: false,
//         ),
//         tooltipBehavior: TooltipBehavior(enable: true),
//         series: <CartesianSeries>[
//           SplineAreaSeries<ChartData, int>(
//             dataLabelMapper: (datum, index) {
//               return (chartData.length - index).toString();
//             },
//             dataLabelSettings: DataLabelSettings(
//               isVisible: true,
//               alignment: ChartAlignment.center,
//               labelAlignment: ChartDataLabelAlignment.outer,
//               textStyle: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: sizeData.regular,
//                 color: colorData.fontColor(.8),
//               ),
//             ),
//             borderWidth: 3,
//             borderGradient: LinearGradient(colors: [
//               colorData.primaryColor(.2),
//               colorData.primaryColor(1),
//             ]),
//             gradient: const LinearGradient(
//               colors: [
//                 Colors.transparent,
//                 Colors.transparent,
//               ],
//             ),
//             enableTooltip: true,
//             markerSettings: MarkerSettings(
//               isVisible: true,
//               borderColor: colorData.primaryColor(1),
//               color: colorData.secondaryColor(1),
//             ),
//             dataSource: chartData,
//             splineType: SplineType.cardinal,
//             cardinalSplineTension: 0.9,
//             xValueMapper: (ChartData data, _) => data.x,
//             yValueMapper: (ChartData data, _) {
//               List<double?> listData = chartData.map((e) => e.y).toList();
//               double sum = 0.0;
//               for (var number in listData) {
//                 sum += number!;
//               }
//               double average = sum / listData.length;
//               return data.y! - average;
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChartData {
//   ChartData(this.x, this.y);
//   final int x;
//   final double? y;
// }
