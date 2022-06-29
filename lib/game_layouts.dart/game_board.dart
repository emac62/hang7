import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hang7/animations/undee_animation.dart';
import 'package:hang7/constants/help.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/constants/progress_messages.dart';
import 'package:hang7/constants/seven_letters.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/end_of_game.dart';
import 'package:hang7/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/widgets/keyboard_row.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/word_grid.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animations/route.dart';
import '../widgets/app_colors.dart';

import '../widgets/size_config.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    required this.prefs,
  }) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<GameBoard> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  late String currentWord = "";
  static String blankWord = "";
  static List containsSelectedLetters = [];
  static List selectedLetters = [];
  static bool showMenu = false;

  double progressValue = 0;
  String progressMessage = "Start by picking a letter.";

  bool showUndee1 = false;
  bool showUndee2 = false;
  bool showUndee3 = false;
  bool showUndee4 = false;
  bool showUndee5 = false;
  bool showUndee6 = false;
  bool showUndee7 = false;

  late bool isTablet;
  late bool isPhone;

  String? undeeColor;
  late Image undeeImage;
  int coins = 0;

  resetControllers() {
    showMenu = false;
    showUndee1 = false;
    showUndee2 = false;
    showUndee3 = false;
    showUndee4 = false;
    showUndee5 = false;
    showUndee6 = false;
    showUndee7 = false;

    progressMessage = "Start by picking a letter.";
    progressValue = 0;

    keysMap.updateAll((key, value) => value = KeyState.unselected);
    debugPrint("before resetgame in resetcontrollers");
    Provider.of<Controller>(context, listen: false).resetGame();
  }

  getWord() {
    final r = Random().nextInt(wordGroup1.length);
    currentWord = wordGroup1[r].toUpperCase();
  }

  getUndeeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    undeeColor = prefs.getString('changeColor');
    debugPrint("UndeeColor: $undeeColor");
    coins = prefs.getInt('coins') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    getWord();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCurrentWord(word: currentWord);
      Provider.of<Controller>(context, listen: false).getDevice();
    });
    undeeColor = widget.prefs.getString('changeColor');
    coins = widget.prefs.getInt("coins") ?? 0;
    debugPrint("init: $currentWord");
  }

  updateProgressCorrect(int num) {
    progressValue = num / 7;
    progressMessage = correctLetterMessage.entries
        .firstWhere((element) => element.key == num)
        .value;
  }

  updateProgressIncorrect(int num) {
    progressMessage = incorrectLetterMessage.entries
        .firstWhere((element) => element.key == (num))
        .value;
    switch (num) {
      case 6:
        showUndee1 = true;

        break;
      case 5:
        showUndee2 = true;

        break;
      case 4:
        showUndee3 = true;

        break;
      case 3:
        showUndee4 = true;

        break;
      case 2:
        showUndee5 = true;

        break;
      case 1:
        showUndee6 = true;

        break;
      case 0:
        showUndee7 = true;

        break;
    }
  }

  toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: ((context, orientation) {
        return Scaffold(
            body: Consumer<Controller>(builder: (_, notifier, __) {
              if (notifier.selectedLetterCorrect) {
                updateProgressCorrect(notifier.correctLetters);
              }
              if (notifier.selectedLetterIncorrect) {
                updateProgressIncorrect(notifier.remainingGuesses);
              }
              if (notifier.gameCompleted && !notifier.gameWon) {
                notifier.revealWord();
                Future.delayed(const Duration(milliseconds: 2000), () {
                  notifier.revealWord();
                });

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(milliseconds: 7000), () {
                    Navigator.push(
                        context,
                        RotationRoute(
                            page: EndOfGame(
                          coinsEarned: 0,
                          prefs: widget.prefs,
                        )));
                  });
                });
              }
              if (notifier.gameWon) {
                debugPrint("gameBoard: Game Won");
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(milliseconds: 4000), () {
                    Navigator.push(
                        context,
                        RotationRoute(
                            page: EndOfGame(
                          prefs: widget.prefs,
                          coinsEarned: (10 + notifier.remainingGuesses),
                        )));
                  });
                });
              }
              if (notifier.isPhone) {
                isPhone = true;
                isTablet = false;
              } else {
                isPhone = false;
                isTablet = true;
              }

              return Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF66B8FE), AppColors.lightGray])),
                height: SizeConfig.safeBlockVertical * 100,
                width: SizeConfig.safeBlockHorizontal * 100,
                child: SafeArea(
                  child: Column(children: [
                    SizedBox(
                      height: isPhone
                          ? SizeConfig.blockSizeVertical * 10
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 12
                              : SizeConfig.blockSizeVertical * 8,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                    primary: AppColors.backgroundColor),
                                child: const Icon(
                                  Icons.menu,
                                  color: AppColors.lightGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    toggleMenu();
                                  });
                                }),
                          ),
                          Positioned(
                            top: 25,
                            left: 20,
                            child: Text(
                              '$coins Coins',
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 4
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 3
                                        : SizeConfig.blockSizeHorizontal * 2,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: isPhone
                                ? SizeConfig.blockSizeHorizontal * 20
                                : SizeConfig.blockSizeHorizontal * 15,
                            child: AnimatedOpacity(
                                opacity: showMenu ? 1.0 : 0,
                                duration: const Duration(milliseconds: 500),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      menuButton(
                                          icon: Icons.refresh,
                                          onPressed: () {
                                            resetControllers();
                                          },
                                          orientation: orientation),
                                      menuButton(
                                          orientation: orientation,
                                          onPressed: () {
                                            setState(() {
                                              toggleMenu();
                                            });
                                            showDialog(
                                                context: context,
                                                builder: (_) => GameStatsAlert(
                                                      coins: coins,
                                                      orientation: orientation,
                                                    ));
                                          },
                                          icon: Icons.bar_chart),
                                      menuButton(
                                          orientation: orientation,
                                          onPressed: () {
                                            toggleMenu();
                                            Navigator.push(
                                                context,
                                                RotationRoute(
                                                    page: Options(
                                                  prefs: widget.prefs,
                                                )));
                                          },
                                          icon: Icons.settings),
                                      menuButton(
                                        orientation: orientation,
                                        onPressed: () {
                                          toggleMenu();
                                          showHelpDialog(context);
                                        },
                                        icon: Icons.help_outline_outlined,
                                      ),
                                    ])),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.transparent, width: 2)),
                              child: Stack(children: <Widget>[
                                isPhone
                                    ? SizedBox(
                                        height: isPhone
                                            ? SizeConfig.blockSizeVertical * 30
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig.blockSizeVertical *
                                                    30
                                                : SizeConfig.blockSizeVertical *
                                                    30,
                                        width: SizeConfig.safeBlockHorizontal *
                                            100,
                                        child: notifier.remainingGuesses != 0
                                            ? Image.asset(
                                                'assets/images/clothesLine.png',
                                                fit: BoxFit.fitWidth,
                                              )
                                            : Image.asset(
                                                'assets/images/clothesLine2.png',
                                                fit: BoxFit.fitWidth,
                                              ),
                                      )
                                    : orientation == Orientation.portrait
                                        ? SizedBox(
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    75,
                                            height: isPhone
                                                ? SizeConfig.blockSizeVertical *
                                                    30.5
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        20
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        25,
                                            child:
                                                notifier.remainingGuesses != 0
                                                    ? Image.asset(
                                                        'assets/images/tabletLine.png',
                                                        fit: BoxFit.fitWidth,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/tabletLine2.png',
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                          )
                                        : SizedBox(
                                            width:
                                                SizeConfig.safeBlockHorizontal *
                                                    60,
                                            height: isPhone
                                                ? SizeConfig.blockSizeVertical *
                                                    30.5
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        30.5
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        30,
                                            child:
                                                notifier.remainingGuesses != 0
                                                    ? Image.asset(
                                                        'assets/images/tabletLine.png',
                                                        fit: BoxFit.fitWidth,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/tabletLine2.png',
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                          ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            'Remaining UnDees',
                                            style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontSize: isPhone
                                                  ? SizeConfig
                                                          .blockSizeHorizontal *
                                                      4
                                                  : orientation ==
                                                          Orientation.portrait
                                                      ? SizeConfig
                                                              .blockSizeHorizontal *
                                                          3
                                                      : SizeConfig
                                                              .blockSizeHorizontal *
                                                          2,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: SizeConfig
                                                      .blockSizeHorizontal *
                                                  10),
                                          child: Text(
                                            notifier.remainingGuesses
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isPhone
                                                  ? SizeConfig
                                                          .blockSizeHorizontal *
                                                      4
                                                  : orientation ==
                                                          Orientation.portrait
                                                      ? SizeConfig
                                                              .blockSizeHorizontal *
                                                          4
                                                      : SizeConfig
                                                              .blockSizeHorizontal *
                                                          2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 2000,
                                  selected: showUndee1,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : orientation == Orientation.portrait
                                          ? 50
                                          : 70,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 1750,
                                  selected: showUndee2,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 16
                                      : orientation == Orientation.portrait
                                          ? 125
                                          : 140,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 1500,
                                  selected: showUndee3,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 26
                                      : orientation == Orientation.portrait
                                          ? 200
                                          : 210,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 1250,
                                  selected: showUndee4,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 36
                                      : orientation == Orientation.portrait
                                          ? 275
                                          : 280,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 1000,
                                  selected: showUndee5,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 46
                                      : orientation == Orientation.portrait
                                          ? 350
                                          : 350,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 750,
                                  selected: showUndee6,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 56
                                      : orientation == Orientation.portrait
                                          ? 425
                                          : 420,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  prefs: widget.prefs,
                                  duration: 500,
                                  selected: showUndee7,
                                  fromLeft: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 66
                                      : orientation == Orientation.portrait
                                          ? 500
                                          : 490,
                                  imgSize: SizeConfig.blockSizeVertical * 10,
                                  orientation: orientation,
                                ),
                                Positioned(
                                    top: 0,
                                    left: SizeConfig.blockSizeHorizontal * 5,
                                    child: AnimatedOpacity(
                                        opacity: (notifier.gameCompleted &&
                                                !notifier.gameWon)
                                            ? 1
                                            : 0,
                                        duration:
                                            const Duration(milliseconds: 2500),
                                        child: Container(
                                          width: orientation ==
                                                  Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  90
                                              : SizeConfig.blockSizeHorizontal *
                                                  50,
                                          height: isPhone
                                              ? SizeConfig.blockSizeVertical *
                                                  30
                                              : orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeVertical *
                                                      30
                                                  : SizeConfig
                                                          .blockSizeVertical *
                                                      30,
                                          decoration: BoxDecoration(
                                              color: AppColors.backgroundColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors.darkBlue,
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "You got a",
                                                    style: TextStyle(
                                                        fontFamily: "Boogaloo",
                                                        fontSize: isPhone
                                                            ? SizeConfig
                                                                    .blockSizeHorizontal *
                                                                5
                                                            : SizeConfig
                                                                    .blockSizeHorizontal *
                                                                4),
                                                  ),
                                                  SizedBox(
                                                    height: isPhone
                                                        ? SizeConfig
                                                                .blockSizeVertical *
                                                            20
                                                        : orientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? SizeConfig
                                                                    .blockSizeVertical *
                                                                25
                                                            : SizeConfig
                                                                    .blockSizeVertical *
                                                                20,
                                                    child: Image.asset(
                                                      'assets/images/wedgie.png',
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))),
                              ]),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 2)),
                      width: SizeConfig.blockSizeHorizontal * 100,
                      height: notifier.isPhone
                          ? SizeConfig.blockSizeVertical * 18
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 20
                              : SizeConfig.blockSizeVertical * 18,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: WordGrid(
                          orientation: orientation,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isPhone
                          ? SizeConfig.blockSizeVertical * 1.5
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 4
                              : SizeConfig.blockSizeVertical * 1,
                    ),
                    KeyboardRow(
                      min: 1,
                      max: 10,
                      orientation: orientation,
                    ),
                    KeyboardRow(
                      min: 11,
                      max: 19,
                      orientation: orientation,
                    ),
                    KeyboardRow(
                      min: 20,
                      max: 26,
                      orientation: orientation,
                    ),
                    SizedBox(
                      height: isPhone
                          ? SizeConfig.blockSizeVertical * 2
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 2
                              : SizeConfig.blockSizeVertical * 1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 10
                              : SizeConfig.blockSizeHorizontal * 20,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Stack(alignment: Alignment.center, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: SizeConfig.blockSizeVertical * 5,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              backgroundColor: const Color(0xFF46AD37),
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2),
                          child: Text(
                            progressMessage,
                            style: TextStyle(
                                color: AppColors.lightGray,
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : SizeConfig.blockSizeHorizontal * 3),
                          ),
                        )
                      ]),
                    ),
                  ]),
                ),
              );
            }),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  color: AppColors.violet,
                  border: Border(
                      top: BorderSide(color: AppColors.darkBlue, width: 2))),
              height: 60,
            ));
      }),
    );
  }

  Padding menuButton(
      {required Orientation orientation,
      required VoidCallback onPressed,
      required IconData icon}) {
    return Padding(
      padding: EdgeInsets.only(
          right: isPhone
              ? SizeConfig.blockSizeHorizontal * 0
              : SizeConfig.blockSizeHorizontal * 5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(6),
              primary: AppColors.backgroundColor),
          onPressed: onPressed,
          child: Icon(
            icon,
            color: AppColors.lightGray,
            size: isPhone
                ? SizeConfig.blockSizeHorizontal * 6
                : orientation == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal * 4
                    : SizeConfig.blockSizeHorizontal * 3,
          )),
    );
  }
}
