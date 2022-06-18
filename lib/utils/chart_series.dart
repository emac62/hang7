import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hang7/data/chart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<charts.Series<ChartModel, String>>> getSeries() async {
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
  return [
    charts.Series<ChartModel, String>(
        id: "Stats",
        data: data,
        domainFn: (model, index) {
          return index.toString();
        },
        measureFn: (model, index) => model.score,
        colorFn: (model, index) {
          if (model.currentGame) {
            return charts.MaterialPalette.green.shadeDefault;
          } else {
            return charts.MaterialPalette.gray.shadeDefault;
          }
        },
        labelAccessorFn: (model, index) => model.score.toString()),
  ];
}
