import 'package:flutter/material.dart';
import 'package:hang7/animations/coin_spin.dart';
import 'package:hang7/animations/route.dart';

import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/banner_ad_widget.dart';
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
  bool withAnimation = true;

  BannerAdContainer bannerAdContainer = const BannerAdContainer();

  void loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = (prefs.getInt('coins') ?? 0);
      withAnimation = (prefs.getBool('withAnimation') ?? true);
    });
  }

  showOutOfWords(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Words!'),
            content: const Text(
                'You have used all the words in this word pack. Go to Options to change your pack or buy more coins if needed.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Get More Words!'),
                onPressed: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: Options(
                        prefs: widget.prefs,
                      )));
                },
              ),
            ],
          );
        });
  }

  int currentWPRemainingWords = 50;
  getCurrentRemainingWords() {
    String wp = widget.prefs.getString('wordPack') ?? "WordPack 1";
    switch (wp) {
      case "WordPack 1":
        List<String> l = widget.prefs.getStringList('usedWords1') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 2":
        List<String> l = widget.prefs.getStringList('usedWords2') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 3":
        List<String> l = widget.prefs.getStringList('usedWords3') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 4":
        List<String> l = widget.prefs.getStringList('usedWords4') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 5":
        List<String> l = widget.prefs.getStringList('usedWords5') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 6":
        List<String> l = widget.prefs.getStringList('usedWords6') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 7":
        List<String> l = widget.prefs.getStringList('usedWords7') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 8":
        List<String> l = widget.prefs.getStringList('usedWords8') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 9":
        List<String> l = widget.prefs.getStringList('usedWords9') ?? [];
        currentWPRemainingWords = l.length;
        break;
      case "WordPack 10":
        List<String> l = widget.prefs.getStringList('usedWords10') ?? [];
        currentWPRemainingWords = l.length;
        break;
    }
  }

  newGame() {
    keysMap.updateAll((key, value) => value = KeyState.unselected);

    Provider.of<Controller>(context, listen: false).resetGame();
    withAnimation
        ? Navigator.pushReplacement(
            context,
            SlideRoute(
                page: GameBoard(
              prefs: widget.prefs,
            )))
        : Navigator.pushReplacement(
            context,
            FadeRoute(
                page: GameBoard(
              prefs: widget.prefs,
            )));
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
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF66B8FE), AppColors.lightGray])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeHorizontal * 2),
                        child: winner
                            ? Text(
                                '${widget.coinsEarned} coins won!',
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                            : Text(
                                "YOU GOT A ",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              ),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: SizeConfig.blockSizeVertical * 8,
                        child: !winner
                            ? Image.asset(
                                "assets/images/wedgie.png",
                                fit: BoxFit.fitHeight,
                              )
                            : settings.withWordAnimation
                                ? const CoinSpinAnimation()
                                : Image.asset(
                                    'assets/images/BasketOfCoins.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                      )),
                      Expanded(
                        child: winner
                            ? Text(
                                "$coins Coins in the Basket",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                            : Text(
                                "Better luck next game!",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
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
                            orientation: orientation,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: orientation == Orientation.portrait ? 4 : 4,
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
                                  withAnimation
                                      ? Navigator.pushReplacement(
                                          context,
                                          SlideRoute(
                                              page: WelcomePage(
                                            prefs: widget.prefs,
                                          )))
                                      : Navigator.pushReplacement(
                                          context,
                                          FadeRoute(
                                              page: WelcomePage(
                                            prefs: widget.prefs,
                                          )));
                                },
                                child: Text(
                                  'Main Menu',
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.green,
                                ),
                                onPressed: () {
                                  getCurrentRemainingWords();
                                  currentWPRemainingWords >= 50
                                      ? showOutOfWords(context)
                                      : newGame();
                                },
                                child: Text(
                                  'New Game',
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                )),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: bannerAdContainer,
              // bottomNavigationBar: Container(
              //   decoration: const BoxDecoration(
              //       color: Colors.transparent,
              //       border: Border(
              //           top: BorderSide(color: Colors.transparent, width: 2))),
              //   height: 60,
              // )
            ),
          );
        }),
      );
    });
  }
}
