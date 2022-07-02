import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeWordPack extends StatefulWidget {
  const ChangeWordPack({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<ChangeWordPack> createState() => _ChangeWordPackState();
}

class _ChangeWordPackState extends State<ChangeWordPack> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.darkBlue),
          backgroundColor: AppColors.backgroundColor,
          toolbarHeight: SizeConfig.blockSizeVertical * 10,
          title: Text(
            "Change My Word Pack",
            style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: orientation == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal * 7
                    : SizeConfig.blockSizeVertical * 6),
          ),
        ),
        body: Consumer<Controller>(builder: (_, notifier, __) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundColor, AppColors.lightGray]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current Words:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: orientation == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal * 7
                            : SizeConfig.blockSizeVertical * 6),
                  ),
                ),
                Text(
                  widget.prefs.getString('wordGroup') ?? "Word Pack 1",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: orientation == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal * 7
                          : SizeConfig.blockSizeVertical * 6),
                ),
                Text(
                  "Each word pack has 100 words.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: orientation == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal * 5
                          : SizeConfig.blockSizeVertical * 4),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: SizeConfig.blockSizeHorizontal * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Word Pack 2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 5
                                : SizeConfig.blockSizeVertical * 4),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('500 Coins'))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: SizeConfig.blockSizeHorizontal * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Word Pack 3",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 5
                                : SizeConfig.blockSizeVertical * 4),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('500 Coins'))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: SizeConfig.blockSizeHorizontal * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Word Pack 4",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 5
                                : SizeConfig.blockSizeVertical * 4),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('500 Coins'))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: SizeConfig.blockSizeHorizontal * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Word Pack 5",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 5
                                : SizeConfig.blockSizeVertical * 4),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('500 Coins'))
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        padding: EdgeInsets.all(
                          notifier.isPhone
                              ? SizeConfig.blockSizeHorizontal * 2
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal * 2
                                  : SizeConfig.blockSizeVertical * 2,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            RotationRoute(
                                page: GameBoard(
                              prefs: widget.prefs,
                            )));
                      },
                      child: Text(
                        "Play",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      );
    });
  }
}
