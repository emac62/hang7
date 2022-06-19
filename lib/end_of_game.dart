import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';

import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/game_layouts.dart/game_board.dart';

import 'package:hang7/providers/controller.dart';
import 'package:hang7/welcome_page.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/stats_bar_chart.dart';
import 'package:hang7/widgets/stats_row.dart';
import 'package:provider/provider.dart';

class EndOfGame extends StatefulWidget {
  const EndOfGame({
    Key? key,
  }) : super(key: key);

  @override
  State<EndOfGame> createState() => _EndOfGameState();
}

class _EndOfGameState extends State<EndOfGame> {
  late bool winner;

  @override
  void initState() {
    super.initState();
    winner = Provider.of<Controller>(context, listen: false).gameWon;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (_, notifier, __) {
      return OrientationBuilder(
        builder: ((context, orientation) {
          return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF66B8FE), AppColors.lightGray])),
                height: SizeConfig.safeBlockVertical * 100,
                width: SizeConfig.safeBlockHorizontal * 100,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 2),
                          child: Text(
                            winner ? "UnDees SAVED!" : "YOU GOT A ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Boogaloo",
                                fontSize: SizeConfig.blockSizeVertical * 4),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 10,
                          child: winner
                              ? Image.asset(
                                  "assets/images/fullBasket.png",
                                  fit: BoxFit.fitHeight,
                                )
                              : Image.asset("assets/images/wedgie.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 2),
                          child: Text(
                            'STATISTICS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Boogaloo",
                                fontSize: SizeConfig.blockSizeVertical * 4),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: StatsRow(
                            orientation: orientation,
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: StatsBarChart(
                              orientation: orientation,
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.green,
                                      ),
                                      onPressed: () {
                                        keysMap.updateAll((key, value) =>
                                            value = KeyState.unselected);

                                        notifier.resetGame();
                                        Navigator.push(
                                            context,
                                            SlideRoute(
                                                page: const WelcomePage()));
                                      },
                                      child: Text(
                                        'Main Menu',
                                        style: TextStyle(
                                          fontSize: orientation ==
                                                  Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  6
                                              : SizeConfig.blockSizeVertical *
                                                  6,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.green,
                                      ),
                                      onPressed: () {
                                        keysMap.updateAll((key, value) =>
                                            value = KeyState.unselected);

                                        notifier.resetGame();
                                        Navigator.push(
                                            context,
                                            RotationRoute(
                                                page: const GameBoard()));
                                      },
                                      child: Text(
                                        'New Game',
                                        style: TextStyle(
                                          fontSize: orientation ==
                                                  Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  6
                                              : SizeConfig.blockSizeVertical *
                                                  6,
                                        ),
                                      )),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                    color: AppColors.violet,
                    border: Border(
                        top: BorderSide(color: AppColors.darkBlue, width: 2))),
                height: 60,
              ));
        }),
      );
    });
  }
}
