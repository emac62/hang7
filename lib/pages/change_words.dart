import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_remaining_words.dart';
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
  List<String> myWordPacks = ["WordPack 1"];
  List<String> availablePacks = [];

  List<String> wordPacks = [
    "WordPack 2",
    "WordPack 3",
    "WordPack 4",
    "WordPack 5",
    "WordPack 6",
    "WordPack 7",
    "WordPack 8",
    "WordPack 9",
    "WordPack 10",
  ];

  late int coins;
  final myWordScrollController = ScrollController();
  final wordScrollController = ScrollController();

  selectWordPack(int index) {
    setState(() {
      widget.prefs.setString('wordPack', availablePacks[index]);
      if (!myWordPacks.contains(availablePacks[index])) {
        myWordPacks.add(availablePacks[index]);
        widget.prefs.setStringList('myWordPacks', myWordPacks);
      }
    });
  }

  List<String> remainingWords = [];

  @override
  void initState() {
    super.initState();

    coins = widget.prefs.getInt('coins') ?? 0;
    myWordPacks = widget.prefs.getStringList('myWordPacks') ?? ["WordPack 1"];
    debugPrint(myWordPacks.toString());
    availablePacks =
        wordPacks.where((element) => !myWordPacks.contains(element)).toList();
    remainingWords = getMyWordPackRemainingWords(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                  AppColors.backgroundColor,
                  AppColors.lightGray
                ]))),
            toolbarHeight: SizeConfig.blockSizeVertical * 8,
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.lightGray,
                      AppColors.backgroundColor,
                    ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("My Word Packs:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeVertical * 4
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 5
                                    : SizeConfig.blockSizeVertical * 4,
                          )),
                    ),
                    Text(
                      "Default (WordPack 1) and all purchased packs.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 2
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 3
                                : SizeConfig.blockSizeVertical * 2,
                      ),
                    ),
                    Text(
                      "Current WordPack is outlined.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 2
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 3
                                : SizeConfig.blockSizeVertical * 2,
                      ),
                    ),
                    Text(
                      "Once all the words are used, repurchase for 100 coins.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 2
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 3
                                : SizeConfig.blockSizeVertical * 2,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 2)),
                      height: orientation == Orientation.portrait
                          ? SizeConfig.blockSizeVertical * 12
                          : SizeConfig.blockSizeVertical * 12,
                      alignment: Alignment.center,
                      child: Scrollbar(
                        controller: myWordScrollController,
                        thumbVisibility: true,
                        thickness: 3,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            controller: myWordScrollController,
                            itemCount: myWordPacks.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.green,
                                        AppColors.lightGray,
                                        AppColors.green
                                      ]),
                                  borderRadius: BorderRadius.circular(6),
                                  border: widget.prefs.getString('wordPack') ==
                                          myWordPacks[index]
                                      ? Border.all(
                                          color: AppColors.darkBlue, width: 3)
                                      : Border.all(
                                          color: Colors.transparent, width: 2),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          int r =
                                              int.parse(remainingWords[index]);
                                          if (r == 0) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: coins > 100
                                                        ? Text(
                                                            "You have used all the words in this pack. Reset for 100 coins?",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          )
                                                        : Text(
                                                            "You need 100 coins to reset this pack.",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (coins > 100) {
                                                                coins =
                                                                    coins - 100;
                                                                widget.prefs
                                                                    .setInt(
                                                                        'coins',
                                                                        coins);
                                                                resetMyWordPackRemainingWords(
                                                                    widget
                                                                        .prefs,
                                                                    myWordPacks[
                                                                        index]);
                                                                widget.prefs.setString(
                                                                    'wordPack',
                                                                    myWordPacks[
                                                                        index]);
                                                                remainingWords =
                                                                    getMyWordPackRemainingWords(
                                                                        widget
                                                                            .prefs);
                                                              }
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          )),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              fontSize: orientation ==
                                                                      Orientation
                                                                          .portrait
                                                                  ? SizeConfig
                                                                          .blockSizeVertical *
                                                                      2
                                                                  : SizeConfig
                                                                          .blockSizeVertical *
                                                                      3,
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                });
                                          } else {
                                            widget.prefs.setString(
                                                'wordPack', myWordPacks[index]);
                                          }
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            myWordPacks[index],
                                            style: TextStyle(
                                              fontSize: orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeVertical *
                                                      2
                                                  : SizeConfig
                                                          .blockSizeVertical *
                                                      3,
                                            ),
                                          ),
                                          Text(
                                            "${remainingWords[index]} words left",
                                            style: TextStyle(
                                              fontSize: orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeVertical *
                                                      2
                                                  : SizeConfig
                                                          .blockSizeVertical *
                                                      1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Available WordPacks",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeVertical * 4
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 5
                                    : SizeConfig.blockSizeVertical * 5,
                          )),
                    ),
                    Text(
                      "Each word pack contains 50 random words.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: notifier.isPhone
                            ? SizeConfig.blockSizeVertical * 2
                            : orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 3
                                : SizeConfig.blockSizeVertical * 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Purchase for 500 coins.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: notifier.isPhone
                              ? SizeConfig.blockSizeVertical * 2
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 3
                                  : SizeConfig.blockSizeVertical * 3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 12,
                      child: Scrollbar(
                        controller: wordScrollController,
                        thumbVisibility: true,
                        thickness: 3,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: wordScrollController,
                            itemCount: availablePacks.length,
                            itemBuilder: ((context, index) {
                              return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: (() {
                                      debugPrint("tapped index: $index");

                                      myWordPacks
                                              .contains(availablePacks[index])
                                          ? null
                                          : showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: coins > 500
                                                      ? Text(
                                                          "Buy ${availablePacks[index]} for 500 coins?",
                                                          style: TextStyle(
                                                            fontSize: notifier
                                                                    .isPhone
                                                                ? SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    6
                                                                : orientation ==
                                                                        Orientation
                                                                            .portrait
                                                                    ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        4
                                                                    : SizeConfig
                                                                            .blockSizeVertical *
                                                                        4,
                                                          ),
                                                        )
                                                      : Text(
                                                          "You don't have enough coins! Keep playing to win more.",
                                                          style: TextStyle(
                                                            fontSize: notifier
                                                                    .isPhone
                                                                ? SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    6
                                                                : orientation ==
                                                                        Orientation
                                                                            .portrait
                                                                    ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        4
                                                                    : SizeConfig
                                                                            .blockSizeVertical *
                                                                        4,
                                                          ),
                                                        ),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: coins >= 500
                                                            ? () {
                                                                setState(() {
                                                                  coins =
                                                                      coins -
                                                                          500;
                                                                  widget.prefs
                                                                      .setInt(
                                                                          'coins',
                                                                          coins);

                                                                  selectWordPack(
                                                                      index);
                                                                });
                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (c,
                                                                            a1,
                                                                            a2) =>
                                                                        ChangeWordPack(
                                                                      prefs: widget
                                                                          .prefs,
                                                                    ),
                                                                    transitionsBuilder: (c,
                                                                            anim,
                                                                            a2,
                                                                            child) =>
                                                                        FadeTransition(
                                                                            opacity:
                                                                                anim,
                                                                            child:
                                                                                child),
                                                                    transitionDuration:
                                                                        const Duration(
                                                                            milliseconds:
                                                                                50),
                                                                  ),
                                                                );
                                                              }
                                                            : () {
                                                                // Go Back
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                        child: coins >= 500
                                                            ? Text(
                                                                "Yes",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: notifier
                                                                          .isPhone
                                                                      ? SizeConfig
                                                                              .blockSizeHorizontal *
                                                                          4
                                                                      : orientation ==
                                                                              Orientation
                                                                                  .portrait
                                                                          ? SizeConfig.blockSizeHorizontal *
                                                                              3
                                                                          : SizeConfig.blockSizeVertical *
                                                                              3,
                                                                ),
                                                              )
                                                            : Text(
                                                                "OK",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: notifier
                                                                          .isPhone
                                                                      ? SizeConfig
                                                                              .blockSizeHorizontal *
                                                                          4
                                                                      : orientation ==
                                                                              Orientation
                                                                                  .portrait
                                                                          ? SizeConfig.blockSizeHorizontal *
                                                                              3
                                                                          : SizeConfig.blockSizeVertical *
                                                                              3,
                                                                ),
                                                              )),
                                                    OutlinedButton(
                                                        onPressed: () {
                                                          // Go Back
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontSize: notifier
                                                                    .isPhone
                                                                ? SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    4
                                                                : orientation ==
                                                                        Orientation
                                                                            .portrait
                                                                    ? SizeConfig
                                                                            .blockSizeHorizontal *
                                                                        3
                                                                    : SizeConfig
                                                                            .blockSizeVertical *
                                                                        3,
                                                          ),
                                                        ))
                                                  ],
                                                );
                                              });
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Ink(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.darkBlue,
                                                  width: 1),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    AppColors.green,
                                                    AppColors.lightGray
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  25,
                                          child: Center(
                                              child: Text(
                                            availablePacks[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeVertical *
                                                        2
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        3),
                                          ))),
                                    ),
                                  ));
                            })),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        height: SizeConfig.blockSizeVertical * 8,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/BasketOfCoins.png"),
                          fit: BoxFit.scaleDown,
                        )),
                        child: Center(
                            child: Text(
                          coins.toString(),
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 6,
                          ),
                        ))),
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
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
                                settingsProvider.withAnimation
                                    ? Navigator.push(
                                        context,
                                        SlideLeftRoute(
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 3),
                                child: Text(
                                  "Back to Options",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3),
                                ),
                              ),
                            ),
                            ElevatedButton(
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
                                keysMap.updateAll((key, value) =>
                                    value = KeyState.unselected);

                                notifier.resetGame();
                                settingsProvider.withAnimation
                                    ? Navigator.push(
                                        context,
                                        RotationRoute(
                                            page: GameBoard(
                                          prefs: widget.prefs,
                                        )))
                                    : Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: GameBoard(
                                          prefs: widget.prefs,
                                        )));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 3),
                                child: Text(
                                  "Play",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
    });
  }
}
