import 'package:flutter/material.dart';
import 'package:hang7/data/chart_model.dart';
import 'package:hang7/utils/chart_series.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsBarChart extends StatelessWidget {
  const StatsBarChart({
    Key? key,
    required this.orientation,
  }) : super(key: key);
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeHorizontal * 1,
          horizontal: orientation == Orientation.landscape
              ? SizeConfig.blockSizeHorizontal * 15
              : SizeConfig.blockSizeHorizontal * 1),
      child: FutureBuilder(
        future: getSeries(),
        builder: (context, snapshot) {
          final List<charts.Series<ChartModel, String>> series;
          if (snapshot.hasData) {
            series = snapshot.data as List<charts.Series<ChartModel, String>>;
            return Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
              child: charts.BarChart(
                series,
                vertical: false,
                domainAxis: const charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                        lineStyle: charts.LineStyleSpec(
                          color: charts.MaterialPalette.transparent,
                        ),
                        labelStyle: charts.TextStyleSpec(fontSize: 14))),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                        lineStyle: charts.LineStyleSpec(
                          color: charts.MaterialPalette.transparent,
                        ),
                        labelStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.transparent))),
                barRendererDecorator: charts.BarLabelDecorator(
                    labelAnchor: charts.BarLabelAnchor.end),
                behaviors: [
                  charts.ChartTitle("UnDees Left!",
                      titleStyleSpec: const charts.TextStyleSpec(
                        fontFamily: "Boogaloo",
                        fontSize: 24,
                      ))
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
