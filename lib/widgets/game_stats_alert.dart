import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/stats_bar_chart.dart';
import 'package:hang7/widgets/stats_row.dart';
import 'package:provider/provider.dart';

class GameStatsAlert extends StatelessWidget {
  const GameStatsAlert(
      {Key? key, required this.orientation, required this.coins})
      : super(key: key);
  final Orientation orientation;
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (_, notifier, __) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.backgroundColor,
                    AppColors.lightGray,
                    AppColors.backgroundColor,
                  ])),
          width: notifier.isPhone
              ? SizeConfig.blockSizeHorizontal * 100
              : SizeConfig.blockSizeHorizontal * 75,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear)),
              ),
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Text(
                  'STATISTICS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Boogaloo",
                      fontSize: SizeConfig.blockSizeVertical * 4),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: StatsRow(
                    coins: coins,
                    orientation: orientation,
                  )),
              Expanded(
                  flex: 4,
                  child: StatsBarChart(
                    orientation: orientation,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
