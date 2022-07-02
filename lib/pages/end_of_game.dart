import 'package:flutter/material.dart';
import 'package:hang7/animations/coin_spin.dart';
import 'package:hang7/animations/route.dart';

import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/stats_bar_chart.dart';
import 'package:hang7/widgets/stats_row.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndOfGame extends StatefulWidget {
  const EndOfGame({
    Key? key,
    required this.coinsEarned,
    required this.prefs,
  }) : super(key: key);
  final int coinsEarned;
  final SharedPreferences prefs;

  @override
  State<EndOfGame> createState() => _EndOfGameState();
}

class _EndOfGameState extends State<EndOfGame> {
  late bool winner;
  int? coins;

  void loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = (prefs.getInt('coins') ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    loadCoins();
    winner = Provider.of<Controller>(context, listen: false).gameWon;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Controller, SettingsProvider>(
        builder: (context, notifier, settings, __) {
      return OrientationBuilder(
        builder: ((context, orientation) {
          return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF66B8FE), AppColors.lightGray])),
                height: orientation == Orientation.portrait
                    ? SizeConfig.safeBlockVertical * 90
                    : SizeConfig.safeBlockVertical * 100,
                width: SizeConfig.safeBlockHorizontal * 100,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 2),
                            child: winner
                                ? Text(
                                    '${widget.coinsEarned} coins won!',
                                    style: TextStyle(
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 6
                                          : SizeConfig.blockSizeVertical * 4,
                                    ),
                                  )
                                : Text(
                                    "YOU GOT A ",
                                    style: TextStyle(
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 6
                                          : SizeConfig.blockSizeVertical * 4,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: SizeConfig.blockSizeVertical * 8,
                            child: winner
                                ? const CoinSpinAnimation()
                                : Image.asset(
                                    "assets/images/wedgie.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: winner
                              ? Text(
                                  "$coins Coins in the Basket",
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                )
                              : Text(
                                  "Better luck next game!",
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                ),
                        ),
                        Text(
                          'STATISTICS',
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 6
                                : SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.transparent, width: 2)),
                            child: StatsRow(
                              coins: coins ?? 0,
                              orientation: orientation,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: orientation == Orientation.portrait ? 4 : 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.transparent, width: 2)),
                              child: StatsBarChart(
                                orientation: orientation,
                              ),
                            )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
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
                                            page: WelcomePage(
                                          prefs: widget.prefs,
                                        )));
                                  },
                                  child: Text(
                                    'Main Menu',
                                    style: TextStyle(
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : SizeConfig.blockSizeVertical * 4,
                                    ),
                                  )),
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
                                              page: GameBoard(
                                            prefs: widget.prefs,
                                          )));
                                    },
                                    child: Text(
                                      'New Game',
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 4,
                                      ),
                                    )),
                              ),
                            ],
                          ),
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
