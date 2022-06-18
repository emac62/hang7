import 'package:shared_preferences/shared_preferences.dart';

setChartStats({required int undeesLeft}) async {
  List<int> distribution = [0, 0, 0, 0, 0, 0, 0, 0];
  List<String> distributionString = [];

  final stats = await getChartStats();

  if (stats != null) {
    distribution = stats;
  }

  for (var i = 0; i < 8; i++) {
    if (undeesLeft == i) {
      distribution[i]++;
    }
  }
  for (var e in distribution) {
    distributionString.add(e.toString());
  }

  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList("chart", distributionString);
  prefs.setInt("undeesLeft", undeesLeft);
}

Future<List<int>?> getChartStats() async {
  final prefs = await SharedPreferences.getInstance();
  final stats = prefs.getStringList("chart");
  if (stats != null) {
    List<int> result = [];
    for (var e in stats) {
      result.add(int.parse(e));
    }
    return result;
  } else {
    return null;
  }
}
