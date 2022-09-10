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
import 'package:hang7/providers/unique_word.dart';
import 'package:hang7/widgets/keyboard_row.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/undees_basket.dart';
import 'package:hang7/widgets/word_grid.dart';
import 'package:provider/provider.dart';
import '../animations/route.dart';
import '../widgets/app_colors.dart';

import '../widgets/banner_ad_widget.dart';
import '../widgets/size_config.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  late String currentWord = "";
  static String blankWord = "";
  static List containsSelectedLetters = [];
  static List selectedLetters = [];
  static bool showMenu = false;

  static double progressValue = 0;
  static String progressMessage = "Start by picking a letter.";

  late Image phoneLine;
  late Image tabletLine;

  static bool showUndee1 = false;
  static bool showUndee2 = false;
  static bool showUndee3 = false;
  static bool showUndee4 = false;
  static bool showUndee5 = false;
  static bool showUndee6 = false;
  static bool showUndee7 = false;

  String? undeeColor;
  late Image undeeImage;
  int coins = 0;
  late double undeeSize;
  late double hWRatio;
  late bool removeAds;

  static resetControllers() {
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
  }

  getData() {
    var setProv = Provider.of<SettingsProvider>(context, listen: false);
    coins = setProv.coins;
    undeeColor = setProv.gameUndees;
  }

  getWord() async {
    var settProv = Provider.of<SettingsProvider>(context, listen: false);
    var uniqProv = Provider.of<UniqueWord>(context, listen: false);
    String pack = settProv.wordPack;

    String listKey = "";
    List<String> words = [];
    List<String> usedWordIndexes = [];
    switch (pack) {
      case "WordPack 1":
        words = wordPack1;
        usedWordIndexes = uniqProv.usedWords1 as List<String>;

        listKey = "usedWords1";
        break;
      case "WordPack 2":
        words = wordPack2;
        usedWordIndexes = uniqProv.usedWords2 as List<String>;

        listKey = "usedWords2";
        break;
      case "WordPack 3":
        words = wordPack3;
        usedWordIndexes = uniqProv.usedWords3 as List<String>;
        listKey = "usedWords3";
        break;
      case "WordPack 4":
        words = wordPack4;
        usedWordIndexes = uniqProv.usedWords4 as List<String>;
        listKey = "usedWords4";
        break;
      case "WordPack 5":
        words = wordPack5;
        usedWordIndexes = uniqProv.usedWords5 as List<String>;
        listKey = "usedWords5";
        break;
      case "WordPack 6":
        words = wordPack6;
        usedWordIndexes = uniqProv.usedWords6 as List<String>;
        listKey = "usedWords6";
        break;
      case "WordPack 7":
        words = wordPack7;
        usedWordIndexes = uniqProv.usedWords7 as List<String>;
        listKey = "usedWords7";
        break;
      case "WordPack 8":
        words = wordPack8;
        usedWordIndexes = uniqProv.usedWords8 as List<String>;
        listKey = "usedWords8";
        break;
      case "WordPack 9":
        words = wordPack9;
        usedWordIndexes = uniqProv.usedWords9 as List<String>;
        listKey = "usedWords9";
        break;
      case "WordPack 10":
        words = wordPack10;
        usedWordIndexes = uniqProv.usedWords10 as List<String>;
        listKey = "usedWords10";
        break;
      default:
    }

    int r = Random().nextInt(words.length);

    String rAsString = r.toString();
    while (usedWordIndexes.contains(rAsString)) {
      r = Random().nextInt(words.length);
      rAsString = r.toString();
    }

    usedWordIndexes.add(rAsString);

    uniqProv.setUsedWordsList(listKey, usedWordIndexes);
    currentWord = words[r].toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    resetControllers();
    getWord();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCurrentWord(word: currentWord);
      Provider.of<Controller>(context, listen: false).getDevice();
    });
    getData();
    phoneLine = Image.asset('assets/images/clothesLine.png');
    tabletLine = Image.asset('assets/images/tabletLine.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(phoneLine.image, context);
    precacheImage(tabletLine.image, context);
  }

  static updateProgressCorrect(int num) {
    progressValue = num / 7;
    progressMessage = correctLetterMessage.entries
        .firstWhere((element) => element.key == num)
        .value;
  }

  static updateProgressIncorrect(int num) {
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
    showMenu = !showMenu;
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    removeAds = settingsProvider.removeAds;
    // debugPrint("gameBoard: removeAds: $removeAds");
    hWRatio = SizeConfig.screenHeight / SizeConfig.screenWidth;
    // debugPrint("hWRatio: $hWRatio");
    return OrientationBuilder(
      builder: ((context, orientation) {
        undeeSize = orientation == Orientation.portrait
            ? SizeConfig.blockSizeVertical * 9
            : SizeConfig.blockSizeHorizontal * 8;
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundColor, AppColors.lightGray])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 2)),
                        height: context.select((Controller c) => c.isPhone)
                            ? 60
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 12
                                : SizeConfig.blockSizeVertical * 9,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 3,
                              right: 8,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(8),
                                      backgroundColor:
                                          AppColors.backgroundColor),
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
                              top: 10,
                              left: 20,
                              child: Text(
                                '$coins Coins',
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 4
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 3
                                          : SizeConfig.blockSizeHorizontal * 2,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: context.select((Controller c) => c.isPhone)
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
                                              toggleMenu();
                                              keysMap.updateAll((key, value) =>
                                                  value = KeyState.unselected);
                                              context.select((Controller c) =>
                                                  c.resetGame());

                                              settingsProvider.withAnimation
                                                  ? Navigator.push(
                                                      context,
                                                      RotationRoute(
                                                          page:
                                                              const WelcomePage()))
                                                  : Navigator.push(
                                                      context,
                                                      FadeRoute(
                                                          page:
                                                              const WelcomePage()));
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
                                                  builder: (_) =>
                                                      GameStatsAlert(
                                                        coins: coins,
                                                        orientation:
                                                            orientation,
                                                      ));
                                            },
                                            icon: Icons.bar_chart),
                                        context.select((Controller c) =>
                                                c.gameCompleted)
                                            ? menuButton(
                                                orientation: orientation,
                                                onPressed: () {
                                                  toggleMenu();

                                                  settingsProvider.withAnimation
                                                      ? Navigator.push(
                                                          context,
                                                          RotationRoute(
                                                              page:
                                                                  const Options()))
                                                      : Navigator.push(
                                                          context,
                                                          FadeRoute(
                                                              page:
                                                                  const Options()));
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
                                context.select((Controller c) => c.isPhone)
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: Image(
                                          image: phoneLine.image,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )
                                    : orientation == Orientation.portrait
                                        ? SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    25,
                                            child: Image(
                                              image: tabletLine.image,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          )
                                        : SizedBox(
                                            height:
                                                SizeConfig.safeBlockVertical *
                                                    35,
                                            child: Image.asset(
                                              'assets/images/tabletLine.png',
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                Positioned(
                                    right: SizeConfig.blockSizeHorizontal * 10,
                                    bottom: context
                                            .select((Controller c) => c.isPhone)
                                        ? SizeConfig.blockSizeVertical * 2
                                        : SizeConfig.blockSizeVertical * 2,
                                    child: const UndeesBasket()),
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
                                            'Remaining Undees',
                                            style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontSize: context.select(
                                                      (Controller c) =>
                                                          c.isPhone)
                                                  ? SizeConfig
                                                          .blockSizeVertical *
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
                                            context.select((Controller c) =>
                                                c.remainingGuesses.toString()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: context.select(
                                                      (Controller c) =>
                                                          c.isPhone)
                                                  ? SizeConfig
                                                          .blockSizeVertical *
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
                                  duration: 2000,
                                  selected: showUndee1,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 8
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 7
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  7
                                              : SizeConfig.blockSizeHorizontal *
                                                  5,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 1750,
                                  selected: showUndee2,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 16
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 19
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  16
                                              : SizeConfig.blockSizeHorizontal *
                                                  12,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 1500,
                                  selected: showUndee3,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 26
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 31
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  25
                                              : SizeConfig.blockSizeHorizontal *
                                                  19,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 1250,
                                  selected: showUndee4,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 36
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 43
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  34
                                              : SizeConfig.blockSizeHorizontal *
                                                  26,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 1000,
                                  selected: showUndee5,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 46
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 55
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  43
                                              : SizeConfig.blockSizeHorizontal *
                                                  33,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 750,
                                  selected: showUndee6,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 56
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 67
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  52
                                              : SizeConfig.blockSizeHorizontal *
                                                  40,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                UndeeAnimation(
                                  duration: 500,
                                  selected: showUndee7,
                                  fromLeft: context
                                          .select((Controller c) => c.isPhone)
                                      ? SizeConfig.blockSizeHorizontal * 66
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 79
                                          : (hWRatio > 0.66)
                                              ? SizeConfig.blockSizeHorizontal *
                                                  61
                                              : SizeConfig.blockSizeHorizontal *
                                                  47,
                                  imgSize: undeeSize,
                                  orientation: orientation,
                                ),
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: AnimatedOpacity(
                                        opacity: (context.select(
                                                    (Controller c) =>
                                                        c.gameCompleted) &&
                                                !context.select(
                                                    (Controller c) =>
                                                        c.gameWon))
                                            ? 1
                                            : 0,
                                        duration:
                                            const Duration(milliseconds: 2500),
                                        child: Container(
                                          alignment: Alignment.topCenter,
                                          width: context.select(
                                                  (Controller c) => c.isPhone)
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
                                                      : (SizeConfig
                                                              .screenWidth *
                                                          0.6),
                                          height: context.select(
                                                  (Controller c) => c.isPhone)
                                              ? SizeConfig.screenWidth * 0.54
                                              : orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeVertical *
                                                      25
                                                  : SizeConfig
                                                          .blockSizeVertical *
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
                                                        fontSize: context.select(
                                                                (Controller
                                                                        c) =>
                                                                    c.isPhone)
                                                            ? SizeConfig
                                                                    .blockSizeHorizontal *
                                                                5
                                                            : SizeConfig
                                                                    .blockSizeHorizontal *
                                                                4),
                                                  ),
                                                  SizedBox(
                                                    height: context.select(
                                                            (Controller c) =>
                                                                c.isPhone)
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 2)),
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: context.select((Controller c) => c.isPhone)
                            ? SizeConfig.blockSizeVertical * 16
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 16
                                : SizeConfig.screenHeight < 740
                                    ? SizeConfig.blockSizeVertical * 10
                                    : SizeConfig.blockSizeVertical * 16,
                        child: Align(
                          alignment: Alignment.center,
                          child: WordGrid(
                            orientation: orientation,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.select((Controller c) => c.isPhone)
                            ? SizeConfig.blockSizeVertical * 1.5
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 4
                                : SizeConfig.blockSizeVertical * 0,
                      ),
                      KeyboardRow(
                        min: 1,
                        max: 10,
                        orientation: orientation,
                        ontap: () {
                          if (context.select(
                              (Controller c) => c.selectedLetterCorrect)) {
                            setState(() {
                              updateProgressCorrect(context
                                  .select((Controller c) => c.correctLetters));
                            });
                          }
                          if (context.select(
                              (Controller c) => c.selectedLetterIncorrect)) {
                            setState(() {
                              updateProgressIncorrect(context.select(
                                  (Controller c) => c.remainingGuesses));
                            });
                          }
                        },
                      ),
                      KeyboardRow(
                        min: 11,
                        max: 19,
                        orientation: orientation,
                        ontap: () {
                          if (context.select(
                              (Controller c) => c.selectedLetterCorrect)) {
                            setState(() {
                              updateProgressCorrect(context
                                  .select((Controller c) => c.correctLetters));
                            });
                          }
                          if (context.select(
                              (Controller c) => c.selectedLetterIncorrect)) {
                            setState(() {
                              updateProgressIncorrect(context.select(
                                  (Controller c) => c.remainingGuesses));
                            });
                          }
                        },
                      ),
                      KeyboardRow(
                        min: 20,
                        max: 26,
                        orientation: orientation,
                        ontap: () {
                          if (context.select(
                              (Controller c) => c.selectedLetterCorrect)) {
                            setState(() {
                              updateProgressCorrect(context
                                  .select((Controller c) => c.correctLetters));
                            });
                          }
                          if (context.select(
                              (Controller c) => c.selectedLetterIncorrect)) {
                            setState(() {
                              updateProgressIncorrect(context.select(
                                  (Controller c) => c.remainingGuesses));
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: context.select((Controller c) => c.isPhone)
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
                              bottom: SizeConfig.blockSizeVertical * 1),
                          child: Stack(alignment: Alignment.center, children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 4.5
                                    : SizeConfig.blockSizeVertical * 3.5,
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
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 4.5
                                        : SizeConfig.blockSizeHorizontal * 2),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ]),
              ),
            ),
            bottomNavigationBar: removeAds
                ? Container(
                    color: AppColors.lightGray,
                    height: 10,
                  )
                : bannerAdContainer,
          ),
        );
      }),
    );
  }

  ElevatedButton menuButton(
      {required Orientation orientation,
      required VoidCallback onPressed,
      required IconData icon}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(6),
            backgroundColor: AppColors.backgroundColor),
        onPressed: onPressed,
        child: Icon(
          icon,
          color: AppColors.lightGray,
        ));
  }
}
