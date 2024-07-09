import 'package:flutter/material.dart';
import 'package:hang7/data/chart_model.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/controller.dart';
import 'app_colors.dart';

int currentGameForStats = 0;

class StatsBarChart extends StatelessWidget {
  const StatsBarChart({
    Key? key,
    required this.orientation,
  }) : super(key: key);
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<Controller>(context);
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 1,
            horizontal: orientation == Orientation.landscape
                ? SizeConfig.blockSizeHorizontal * 15
                : SizeConfig.blockSizeHorizontal * 1),
        child: FutureBuilder(
          future: getChartData(),
          builder: ((context, snapshot) {
            final List<ChartModel> chartData;
            if (snapshot.hasData) {
              chartData = snapshot.data as List<ChartModel>;
              for (int i = 0; i < chartData.length; i++) {
                if (chartData[i].currentGame == true) {
                  currentGameForStats = i;
                }
              }

              return SfCartesianChart(
                series: <CartesianSeries>[
                  BarSeries<ChartModel, String>(
                      animationDelay: controller.gameWon ? 1750 : 0,
                      animationDuration: 1000,
                      dataSource: chartData,
                      xValueMapper: ((datum, index) => index.toString()),
                      yValueMapper: ((datum, index) => datum.score),
                      width: 1.0,
                      spacing: 0.25,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      onCreateRenderer: (series) {
                        return CustomBarColor();
                      },
                      dataLabelSettings: DataLabelSettings(
                          labelAlignment: ChartDataLabelAlignment.top,
                          isVisible: true,
                          textStyle: TextStyle(
                              // color: AppColors.lightGray,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 2
                                  : SizeConfig.blockSizeVertical * 1.75)))
                ],
                primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    isInversed: true,
                    borderWidth: 0,
                    labelStyle: TextStyle(
                        color: AppColors.darkBlue,
                        fontFamily: "Boogaloo",
                        fontSize: SizeConfig.blockSizeVertical * 2)),
                primaryYAxis: const NumericAxis(isVisible: false),
                title: ChartTitle(
                    text: "Remaining Undees",
                    textStyle: TextStyle(
                        color: AppColors.darkBlue,
                        fontFamily: "Boogaloo",
                        fontSize: SizeConfig.blockSizeVertical * 2.5)),
                borderColor: Colors.transparent,
                plotAreaBorderWidth: 0,
              );
            } else {
              return const SizedBox();
            }
          }),
        ));
  }

  Future<List<ChartModel>> getChartData() async {
    List<ChartModel> data = [];
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList("chart");
    final undeesLeft = prefs.getInt("undeesLeft");
    if (scores != null) {
      for (var e in scores) {
        data.add(ChartModel(score: int.parse(e), currentGame: false));
      }
    }
    if (undeesLeft != null) {
      data[undeesLeft].currentGame = true;
    }
    return data;
  }
}

class CustomBarColor extends BarSeriesRenderer<ChartModel, String> {
  CustomBarColor();
  @override
  BarSegment<ChartModel, String> createSegment() {
    return BarCustomPainter();
  }
}

class BarCustomPainter extends BarSegment<ChartModel, String> {
  final colorList = [AppColors.greenGray, AppColors.green];

  @override
  Paint getFillPaint() {
    final Paint customFillPaint = Paint();
    customFillPaint.isAntiAlias = false;
    customFillPaint.color = currentSegmentIndex == currentGameForStats
        ? colorList[1]
        : colorList[0];
    customFillPaint.style = PaintingStyle.fill;
    return customFillPaint;
  }
}
