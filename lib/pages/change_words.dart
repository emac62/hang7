import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
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
  List<String> myWordPacks = ["WorkPack 1"];

  List<String> wordPacks = [
    "WorkPack 2",
    "WorkPack 3",
    "WorkPack 4",
    "WorkPack 5",
    "WorkPack 6",
    "WorkPack 7",
    "WorkPack 8",
    "WorkPack 9",
    "WorkPack 10",
  ];

  late int coins;
  final myWordScrollController = ScrollController();
  final wordScrollController = ScrollController();

  selectWordPack(int index) {
    setState(() {
      switch (index) {
        case 0:
          widget.prefs.setString('wordPack', "WordPack 2");
          if (!myWordPacks.contains("WordPack 2")) {
            myWordPacks.add("WordPack 2");

            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 1:
          widget.prefs.setString('wordPack', "WordPack 3");
          if (!myWordPacks.contains("WordPack 3")) {
            myWordPacks.add("WordPack 3");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 2:
          widget.prefs.setString('wordPack', "WordPack 4");
          if (!myWordPacks.contains("WordPack 4")) {
            myWordPacks.add("WordPack 4");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 3:
          widget.prefs.setString('wordPack', "WordPack 5");
          if (!myWordPacks.contains("WordPack 5")) {
            myWordPacks.add("WordPack 5");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 4:
          widget.prefs.setString('wordPack', "WordPack 6");
          if (!myWordPacks.contains("WordPack 6")) {
            myWordPacks.add("WordPack 6");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 5:
          widget.prefs.setString('wordPack', "WordPack 7");
          if (!myWordPacks.contains("WordPack 7")) {
            myWordPacks.add("WordPack 7");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 6:
          widget.prefs.setString('wordPack', "WordPack 8");
          if (!myWordPacks.contains("WordPack 8")) {
            myWordPacks.add("WordPack 8");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 7:
          widget.prefs.setString('wordPack', "WordPack 9");
          if (!myWordPacks.contains("WordPack 9")) {
            myWordPacks.add("WordPack 9");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 8:
          widget.prefs.setString('wordPack', "WordPack 10");
          if (!myWordPacks.contains("WordPack 10")) {
            myWordPacks.add("WordPack 10");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    coins = widget.prefs.getInt('coins') ?? 0;
    myWordPacks = widget.prefs.getStringList('myWordPacks') ?? ["WordPack 1"];
    debugPrint(myWordPacks.toString());
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
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "My Word Packs:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 6
                              : SizeConfig.blockSizeVertical * 4),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    height: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 6
                        : SizeConfig.blockSizeVertical * 8,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: widget.prefs.getString('wordPack') ==
                                        myWordPacks[index]
                                    ? Border.all(
                                        color: AppColors.darkBlue, width: 2)
                                    : Border.all(
                                        color: Colors.transparent, width: 2),
                              ),
                              height: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 25
                                  : SizeConfig.blockSizeVertical * 20,
                              width: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 15
                                  : SizeConfig.blockSizeHorizontal * 18,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.prefs.setString(
                                            'wordPack', myWordPacks[index]);
                                        debugPrint(
                                            "myWords: ${myWordPacks[index]}");
                                        debugPrint(
                                            widget.prefs.getString('wordPack'));
                                      });
                                    },
                                    child: Text(
                                      myWordPacks[index],
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeVertical * 2
                                            : SizeConfig.blockSizeVertical * 3,
                                      ),
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
                    child: Text(
                      "Each word pack contains 50 random words.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 5
                              : SizeConfig.blockSizeVertical * 4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Purchase for 5 coins.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 5
                              : SizeConfig.blockSizeVertical * 4),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 15,
                    width: SizeConfig.blockSizeHorizontal * 25,
                    child: Scrollbar(
                      controller: wordScrollController,
                      thumbVisibility: true,
                      thickness: 3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: wordScrollController,
                          itemCount: wordPacks.length,
                          itemBuilder: ((context, index) {
                            return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (() {
                                    debugPrint("inkwell: $index");
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: coins > 5
                                                ? Text(
                                                    "Buy ${wordPacks[index]} for 5 coins?",
                                                    style: TextStyle(
                                                      fontSize: notifier.isPhone
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
                                                      fontSize: notifier.isPhone
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
                                                  onPressed: coins >= 5
                                                      ? () {
                                                          setState(() {
                                                            coins = coins - 5;
                                                            widget.prefs.setInt(
                                                                'coins', coins);

                                                            selectWordPack(
                                                                index);
                                                          });
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (c,
                                                                      a1, a2) =>
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
                                                  child: coins >= 5
                                                      ? Text(
                                                          "Yes",
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
                                                        )
                                                      : Text(
                                                          "OK",
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
                                                        )),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    // Go Back
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontSize: notifier.isPhone
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
                                        height:
                                            SizeConfig.blockSizeVertical * 8,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 20,
                                        child: Center(
                                            child: Text(
                                          wordPacks[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeVertical *
                                                      2.5
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
                                    fontSize: SizeConfig.blockSizeVertical * 3),
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
                              keysMap.updateAll(
                                  (key, value) => value = KeyState.unselected);

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
                                    fontSize: SizeConfig.blockSizeVertical * 3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
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
