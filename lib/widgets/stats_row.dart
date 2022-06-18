import 'package:flutter/material.dart';
import 'package:hang7/data/get_stats.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/stats_box.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    Key? key,
    required this.orientation,
  }) : super(key: key);
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getGameStats(),
      builder: (context, AsyncSnapshot snapshot) {
        List<String> results = ['0', '0', '0', '0', '0', '0', '0'];
        if (snapshot.hasData) {
          results = snapshot.data as List<String>;
        }
        return Padding(
          padding: orientation == Orientation.portrait
              ? EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 5)
              : EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 15),
          child: Row(
            children: [
              StatsBox(
                heading: 'Played',
                value: int.parse(results[0]),
              ),
              StatsBox(heading: 'Win %', value: int.parse(results[2])),
              StatsBox(
                  heading: 'Current\nStreak', value: int.parse(results[3])),
              StatsBox(heading: 'Max\nStreak', value: int.parse(results[4])),
              StatsBox(
                  heading: "Average\nUndees\nLeft",
                  value: int.parse(results[6]))
            ],
          ),
        );
      },
    );
  }
}
