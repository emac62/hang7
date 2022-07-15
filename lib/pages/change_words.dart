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
  List<String> myWordPacks = ["Random 1"];

  List<String> wordPacks = [
    "Random 2",
    "Random 3",
    "Random 4",
    "Random 5",
    "Random 6",
    "Random 7",
    "Random 8",
    "Random 9",
    "Random 10",
  ];

  late int coins;

  selectWordPack(int index) {
    setState(() {
      switch (index) {
        case 0:
          widget.prefs.setString('wordGroup', "Random 2");
          if (!myWordPacks.contains("Random 2")) {
            myWordPacks.add("Random 2");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 1:
          widget.prefs.setString('wordGroup', "Random 3");
          if (!myWordPacks.contains("Random 3")) {
            myWordPacks.add("Random 3");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 2:
          widget.prefs.setString('wordGroup', "Random 4");
          if (!myWordPacks.contains("Random 4")) {
            myWordPacks.add("Random 4");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        case 3:
          widget.prefs.setString('wordGroup', "Random 5");
          if (!myWordPacks.contains("Random 5")) {
            myWordPacks.add("Random 5");
            widget.prefs.setStringList('myWordPacks', myWordPacks);
          }
          break;
        default:
      }
    });
  }

  int selected = 0;
  double itemWidth = 60;
  int itemCount = 1;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 4);

  @override
  void initState() {
    super.initState();
    coins = widget.prefs.getInt('coins') ?? 0;
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
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.lightGray,
                      AppColors.backgroundColor,
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: myWordPacks.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: widget.prefs.getString('wordGroup') ==
                                      myWordPacks[index]
                                  ? Border.all(
                                      color: AppColors.darkBlue, width: 2)
                                  : Border.all(
                                      color: Colors.transparent, width: 2),
                            ),
                            height: SizeConfig.blockSizeVertical * 20,
                            width: SizeConfig.blockSizeHorizontal * 15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.prefs.setString(
                                          'wordGroup', myWordPacks[index]);
                                      debugPrint(
                                          "myWords: ${myWordPacks[index]}");
                                      debugPrint(
                                          widget.prefs.getString('wordGroup'));
                                    });
                                  },
                                  child: Text(
                                    myWordPacks[index],
                                    style: TextStyle(
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeVertical * 2
                                          : SizeConfig.blockSizeVertical * 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Each word pack contains 50 words.",
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
                      "Buy for 500 coins.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 5
                              : SizeConfig.blockSizeVertical * 4),
                    ),
                  ),
                  Flexible(
                    child: RotatedBox(
                        quarterTurns: -1,
                        child: ListWheelScrollView.useDelegate(
                          controller: _scrollController,
                          diameterRatio: 4,
                          itemExtent: 200,
                          clipBehavior: Clip.antiAlias,
                          squeeze: 0.85,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                              childCount: wordPacks.length,
                              builder: (BuildContext context, int index) {
                                // if (index < 0 || index > wordPacks.length + 1) {
                                //   return null;
                                // }

                                return RotatedBox(
                                    quarterTurns: 1,
                                    child: GestureDetector(
                                        onTap: () {
                                          debugPrint(index.toString());
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: coins > 100
                                                      ? Text(
                                                          "Buy ${wordPacks[index]} for 500 coins?",
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
                                                                coins =
                                                                    coins - 500;
                                                                widget.prefs
                                                                    .setInt(
                                                                        'coins',
                                                                        coins);
                                                                selectWordPack(
                                                                    index);
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
                                                                                500),
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  AppColors.green,
                                                  AppColors.lightGray
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppColors.darkBlue,
                                                width: 2),
                                            //
                                          ),
                                          child: Center(
                                            child: Text(
                                              wordPacks[index],
                                              style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeVertical *
                                                    3,
                                              ),
                                            ),
                                          ),
                                        )));
                              }),
                        )),
                  ),

                  // Flexible(
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: GridView.builder(
                  //       itemCount: wordPacks.length,
                  //       itemBuilder: (context, index) {
                  //         return GestureDetector(
                  //             onTap: () {
                  //               debugPrint(index.toString());
                  //               showDialog(
                  //                   context: context,
                  //                   builder: (context) {
                  //                     return AlertDialog(
                  //                       content: coins > 100
                  //                           ? Text(
                  //                               "Buy ${wordPacks[index]} for 500 coins?",
                  //                               style: TextStyle(
                  //                                 fontSize: notifier.isPhone
                  //                                     ? SizeConfig
                  //                                             .blockSizeHorizontal *
                  //                                         6
                  //                                     : orientation ==
                  //                                             Orientation
                  //                                                 .portrait
                  //                                         ? SizeConfig
                  //                                                 .blockSizeHorizontal *
                  //                                             4
                  //                                         : SizeConfig
                  //                                                 .blockSizeVertical *
                  //                                             4,
                  //                               ),
                  //                             )
                  //                           : Text(
                  //                               "You don't have enough coins! Keep playing to win more.",
                  //                               style: TextStyle(
                  //                                 fontSize: notifier.isPhone
                  //                                     ? SizeConfig
                  //                                             .blockSizeHorizontal *
                  //                                         6
                  //                                     : orientation ==
                  //                                             Orientation
                  //                                                 .portrait
                  //                                         ? SizeConfig
                  //                                                 .blockSizeHorizontal *
                  //                                             4
                  //                                         : SizeConfig
                  //                                                 .blockSizeVertical *
                  //                                             4,
                  //                               ),
                  //                             ),
                  //                       actions: [
                  //                         ElevatedButton(
                  //                             onPressed: coins >= 500
                  //                                 ? () {
                  //                                     coins = coins - 500;
                  //                                     widget.prefs.setInt(
                  //                                         'coins', coins);
                  //                                     selectWordPack(index);
                  //                                     Navigator.push(
                  //                                       context,
                  //                                       PageRouteBuilder(
                  //                                         pageBuilder: (c, a1,
                  //                                                 a2) =>
                  //                                             ChangeWordPack(
                  //                                           prefs: widget.prefs,
                  //                                         ),
                  //                                         transitionsBuilder: (c,
                  //                                                 anim,
                  //                                                 a2,
                  //                                                 child) =>
                  //                                             FadeTransition(
                  //                                                 opacity: anim,
                  //                                                 child: child),
                  //                                         transitionDuration:
                  //                                             const Duration(
                  //                                                 milliseconds:
                  //                                                     500),
                  //                                       ),
                  //                                     );
                  //                                   }
                  //                                 : () {
                  //                                     // Go Back
                  //                                     Navigator.pop(context);
                  //                                   },
                  //                             child: coins >= 500
                  //                                 ? Text(
                  //                                     "Yes",
                  //                                     style: TextStyle(
                  //                                       fontSize: notifier
                  //                                               .isPhone
                  //                                           ? SizeConfig
                  //                                                   .blockSizeHorizontal *
                  //                                               4
                  //                                           : orientation ==
                  //                                                   Orientation
                  //                                                       .portrait
                  //                                               ? SizeConfig
                  //                                                       .blockSizeHorizontal *
                  //                                                   3
                  //                                               : SizeConfig
                  //                                                       .blockSizeVertical *
                  //                                                   3,
                  //                                     ),
                  //                                   )
                  //                                 : Text(
                  //                                     "OK",
                  //                                     style: TextStyle(
                  //                                       fontSize: notifier
                  //                                               .isPhone
                  //                                           ? SizeConfig
                  //                                                   .blockSizeHorizontal *
                  //                                               4
                  //                                           : orientation ==
                  //                                                   Orientation
                  //                                                       .portrait
                  //                                               ? SizeConfig
                  //                                                       .blockSizeHorizontal *
                  //                                                   3
                  //                                               : SizeConfig
                  //                                                       .blockSizeVertical *
                  //                                                   3,
                  //                                     ),
                  //                                   )),
                  //                         OutlinedButton(
                  //                             onPressed: () {
                  //                               // Go Back
                  //                               Navigator.pop(context);
                  //                             },
                  //                             child: Text(
                  //                               "Cancel",
                  //                               style: TextStyle(
                  //                                 fontSize: notifier.isPhone
                  //                                     ? SizeConfig
                  //                                             .blockSizeHorizontal *
                  //                                         4
                  //                                     : orientation ==
                  //                                             Orientation
                  //                                                 .portrait
                  //                                         ? SizeConfig
                  //                                                 .blockSizeHorizontal *
                  //                                             3
                  //                                         : SizeConfig
                  //                                                 .blockSizeVertical *
                  //                                             3,
                  //                               ),
                  //                             ))
                  //                       ],
                  //                     );
                  //                   });
                  //             },
                  //             child: Container(
                  //               //
                  //               decoration: BoxDecoration(
                  //                 gradient: const LinearGradient(
                  //                     begin: Alignment.topCenter,
                  //                     end: Alignment.bottomCenter,
                  //                     colors: [
                  //                       AppColors.green,
                  //                       AppColors.lightGray
                  //                     ]),
                  //                 borderRadius: BorderRadius.circular(6),
                  //                 border: Border.all(
                  //                     color: AppColors.darkBlue, width: 2),
                  //                 //
                  //               ),
                  //               child: Center(
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text(
                  //                     wordPacks[index],
                  //                     style: TextStyle(
                  //                       fontSize:
                  //                           SizeConfig.blockSizeVertical * 3,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ));
                  //       },
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           mainAxisSpacing: 10, //horizontal space
                  //           crossAxisSpacing: 10, //vertical space
                  //           crossAxisCount: 5,
                  //           childAspectRatio:
                  //               orientation == Orientation.portrait ? 1.5 : 4),
                  //     ),
                  //   ),
                  // ),
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
