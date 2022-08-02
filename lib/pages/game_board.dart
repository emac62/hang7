import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hang7/animations/undee_animation.dart';
import 'package:hang7/constants/help.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/constants/progress_messages.dart';
import 'package:hang7/constants/seven_letters.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/keyboard_row.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/undees_basket.dart';
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
  late double undeeSize;
  late double hWRatio;

  // resetControllers() {
  //   showMenu = false;
  //   showUndee1 = false;
  //   showUndee2 = false;
  //   showUndee3 = false;
  //   showUndee4 = false;
  //   showUndee5 = false;
  //   showUndee6 = false;
  //   showUndee7 = false;

  //   progressMessage = "Start by picking a letter.";
  //   progressValue = 0;

  //   keysMap.updateAll((key, value) => value = KeyState.unselected);
  //   debugPrint("before resetgame in resetcontrollers");
  //   Provider.of<Controller>(context, listen: false).resetGame();
  // }

  getWord() {
    String group = widget.prefs.getString('wordPack') ?? "WordPack 1";
    debugPrint("getWord group: $group");
    String listKey = "";
    List<String> words = [];
    List<String> usedWordIndexes = [];
    switch (group) {
      case "WordPack 1":
        words = wordPack1;
        usedWordIndexes = widget.prefs.getStringList('usedWords1') ?? [];
        listKey = "usedWords1";
        break;
      case "WordPack 2":
        words = wordPack2;
        usedWordIndexes = widget.prefs.getStringList('usedWords2') ?? [];
        listKey = "usedWords2";
        break;
      case "WordPack 3":
        words = wordPack3;
        usedWordIndexes = widget.prefs.getStringList('usedWords3') ?? [];
        listKey = "usedWords3";
        break;
      case "WordPack 4":
        words = wordPack4;
        usedWordIndexes = widget.prefs.getStringList('usedWords4') ?? [];
        listKey = "usedWords4";
        break;
      case "WordPack 5":
        words = wordPack5;
        usedWordIndexes = widget.prefs.getStringList('usedWords5') ?? [];
        listKey = "usedWords5";
        break;
      case "WordPack 6":
        words = wordPack6;
        usedWordIndexes = widget.prefs.getStringList('usedWords6') ?? [];
        listKey = "usedWords6";
        break;
      case "WordPack 7":
        words = wordPack7;
        usedWordIndexes = widget.prefs.getStringList('usedWords7') ?? [];
        listKey = "usedWords7";
        break;
      case "WordPack 8":
        words = wordPack8;
        usedWordIndexes = widget.prefs.getStringList('usedWords8') ?? [];
        listKey = "usedWords8";
        break;
      case "WordPack 9":
        words = wordPack9;
        usedWordIndexes = widget.prefs.getStringList('usedWords9') ?? [];
        listKey = "usedWords9";
        break;
      case "WordPack 10":
        words = wordPack10;
        usedWordIndexes = widget.prefs.getStringList('usedWords10') ?? [];
        listKey = "usedWords10";
        break;
      default:
    }
    int r = Random().nextInt(words.length);
    debugPrint("first Random: $r");
    String rAsString = r.toString();

    debugPrint("else called");
    while (usedWordIndexes.contains(rAsString)) {
      r = Random().nextInt(words.length);
      rAsString = r.toString();
    }
    debugPrint("random String: $rAsString");
    debugPrint(usedWordIndexes.toString());
    usedWordIndexes.add(rAsString);
    widget.prefs.setStringList(listKey, usedWordIndexes);
    currentWord = words[r].toUpperCase();
    debugPrint("getWord: $currentWord");
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
    var settingsProvider = Provider.of<SettingsProvider>(context);
    debugPrint("Screen width: ${SizeConfig.screenWidth}");
    debugPrint("Screen safeBlockHorizontal: ${SizeConfig.safeBlockHorizontal}");
    debugPrint("Screen width: ${SizeConfig.screenWidth}");
    debugPrint("Screen safeBlockVertical: ${SizeConfig.safeBlockVertical}");
    debugPrint("Screen height: ${SizeConfig.screenHeight}");
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
              }

              if (notifier.isPhone) {
                isPhone = true;
                isTablet = false;
                debugPrint("isPhone: $isPhone");
              } else {
                isPhone = false;
                isTablet = true;
                debugPrint("isTablet: $isTablet");
              }

              undeeSize = orientation == Orientation.portrait
                  ? SizeConfig.blockSizeVertical * 9
                  : SizeConfig.blockSizeHorizontal * 8;

              hWRatio = SizeConfig.screenHeight / SizeConfig.screenWidth;
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
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 2)),
                      height: isPhone
                          ? 60
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 12
                              : SizeConfig.blockSizeVertical * 8,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 3,
                            right: 8,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(8),
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
                            top: 6,
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
                                            keysMap.updateAll((key, value) =>
                                                value = KeyState.unselected);
                                            notifier.resetGame();

                                            settingsProvider.withAnimation
                                                ? Navigator.push(
                                                    context,
                                                    RotationRoute(
                                                        page: WelcomePage(
                                                      prefs: widget.prefs,
                                                    )))
                                                : Navigator.push(
                                                    context,
                                                    FadeRoute(
                                                        page: WelcomePage(
                                                      prefs: widget.prefs,
                                                    )));
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
                                      notifier.gameCompleted
                                          ? menuButton(
                                              orientation: orientation,
                                              onPressed: () {
                                                toggleMenu();

                                                settingsProvider.withAnimation
                                                    ? Navigator.push(
                                                        context,
                                                        RotationRoute(
                                                            page: Options(
                                                          prefs: widget.prefs,
                                                        )))
                                                    : Navigator.push(
                                                        context,
                                                        FadeRoute(
                                                            page: Options(
                                                          prefs: widget.prefs,
                                                        )));
                                              },
                                              icon: Icons.settings)
                                          : const Text(""),
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
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.transparent, width: 2)),
                            child: Stack(children: <Widget>[
                              isPhone
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Image.asset(
                                        'assets/images/clothesLine.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : orientation == Orientation.portrait
                                      ? SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical * 25,
                                          child: Image.asset(
                                            'assets/images/tabletLine.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )
                                      : SizedBox(
                                          height:
                                              SizeConfig.safeBlockVertical * 35,
                                          child: Image.asset(
                                            'assets/images/tabletLine.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                              Positioned(
                                  right: SizeConfig.blockSizeHorizontal * 10,
                                  bottom: notifier.isPhone
                                      ? SizeConfig.blockSizeVertical * 4
                                      : SizeConfig.blockSizeVertical * 2,
                                  child: UndeesBasket(
                                    prefs: widget.prefs,
                                  )),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(
                                          'Remaining UnDees',
                                          style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontSize: isPhone
                                                ? SizeConfig.blockSizeVertical *
                                                    2
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        2
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    10
                                                : SizeConfig
                                                        .blockSizeHorizontal *
                                                    6),
                                        child: Text(
                                          notifier.remainingGuesses.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isPhone
                                                ? SizeConfig.blockSizeVertical *
                                                    3
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        2.5
                                                    : SizeConfig
                                                            .blockSizeVertical *
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
                                    ? SizeConfig.blockSizeHorizontal * 8
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 7
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal * 7
                                            : SizeConfig.blockSizeHorizontal *
                                                5,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 1750,
                                selected: showUndee2,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 16
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 19
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                16
                                            : SizeConfig.blockSizeHorizontal *
                                                12,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 1500,
                                selected: showUndee3,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 26
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 31
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                25
                                            : SizeConfig.blockSizeHorizontal *
                                                19,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 1250,
                                selected: showUndee4,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 36
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 43
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                34
                                            : SizeConfig.blockSizeHorizontal *
                                                26,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 1000,
                                selected: showUndee5,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 46
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 55
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                43
                                            : SizeConfig.blockSizeHorizontal *
                                                33,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 750,
                                selected: showUndee6,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 56
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 67
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                52
                                            : SizeConfig.blockSizeHorizontal *
                                                40,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              UndeeAnimation(
                                prefs: widget.prefs,
                                duration: 500,
                                selected: showUndee7,
                                fromLeft: isPhone
                                    ? SizeConfig.blockSizeHorizontal * 66
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 79
                                        : (hWRatio > 0.65)
                                            ? SizeConfig.blockSizeHorizontal *
                                                61
                                            : SizeConfig.blockSizeHorizontal *
                                                47,
                                imgSize: undeeSize,
                                orientation: orientation,
                              ),
                              Positioned(
                                  top: 0,
                                  left: isPhone
                                      ? SizeConfig.blockSizeHorizontal * 5
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 2
                                          : SizeConfig.blockSizeHorizontal * 0,
                                  child: AnimatedOpacity(
                                      opacity: (notifier.gameCompleted &&
                                              !notifier.gameWon)
                                          ? 1
                                          : 0,
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        width: isPhone
                                            ? SizeConfig.blockSizeHorizontal *
                                                90
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    97
                                                : (hWRatio > 0.65)
                                                    ? SizeConfig.screenWidth *
                                                        0.76
                                                    : (SizeConfig.screenWidth *
                                                        0.6),
                                        height: isPhone
                                            ? SizeConfig.screenWidth * 0.54
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig.blockSizeVertical *
                                                    25
                                                : SizeConfig.blockSizeVertical *
                                                    35,
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
                                                              15
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
                        ]),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 2)),
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 16
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 20
                                : SizeConfig.blockSizeVertical * 18,
                        child: Align(
                          alignment: Alignment.center,
                          child: WordGrid(
                            orientation: orientation,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isPhone
                          ? SizeConfig.blockSizeVertical * 1.5
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 4
                              : SizeConfig.blockSizeVertical * 0,
                    ),
                    KeyboardRow(
                      prefs: widget.prefs,
                      min: 1,
                      max: 10,
                      orientation: orientation,
                    ),
                    KeyboardRow(
                      prefs: widget.prefs,
                      min: 11,
                      max: 19,
                      orientation: orientation,
                    ),
                    KeyboardRow(
                      prefs: widget.prefs,
                      min: 20,
                      max: 26,
                      orientation: orientation,
                    ),
                    SizedBox(
                      height: isPhone
                          ? SizeConfig.blockSizeVertical * 1
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 2
                              : SizeConfig.blockSizeVertical * 0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 10
                              : SizeConfig.blockSizeHorizontal * 20,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 2),
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
                    ),
                  ]),
                ),
              );
            }),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                      top: BorderSide(color: Colors.transparent, width: 2))),
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
