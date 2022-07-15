import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUndees extends StatefulWidget {
  const ChangeUndees({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<ChangeUndees> createState() => _ChangeUndeesState();
}

class _ChangeUndeesState extends State<ChangeUndees> {
  late String undeesStr;
  late List<String> undColour;

  late int coins;

  List<Widget> images = [
    Image.asset(
      'assets/images/greenPlaid.png',
    ),
    Image.asset(
      'assets/images/whiteUndees.png',
    ),
    Image.asset(
      'assets/images/blueUndees.png',
    ),
    Image.asset(
      'assets/images/whiteTighties.png',
    ),
    Image.asset(
      'assets/images/grayTighties.png',
    ),
    Image.asset(
      'assets/images/blueTighties.png',
    ),
  ];

  selectUndees(int index) {
    setState(() {
      switch (index) {
        case 0:
          widget.prefs.setString('changeColor', "Pink");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          break;
        case 1:
          widget.prefs.setString('changeColor', "White");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          if (!undColour.contains("White")) {
            undColour.add("White");
            widget.prefs.setStringList('undeeColours', undColour);
            myUndees.add(Image.asset(
              'assets/images/whiteUndees.png',
            ));
          }

          break;
        case 2:
          widget.prefs.setString('changeColor', "DarkBlue");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          if (!undColour.contains("DarkBlue")) {
            undColour.add("DarkBlue");
            widget.prefs.setStringList('undeeColours', undColour);
            myUndees.add(Image.asset(
              'assets/images/blueUndees.png',
            ));
          }
          break;
        case 3:
          widget.prefs.setString('changeColor', "WhiteTighties");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          if (!undColour.contains("WhiteTighties")) {
            undColour.add("WhiteTighties");
            widget.prefs.setStringList('undeeColours', undColour);
            myUndees.add(Image.asset(
              'assets/images/whiteTighties.png',
            ));
          }
          break;
        case 4:
          widget.prefs.setString('changeColor', "GrayTighties");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          if (!undColour.contains("GrayTighties")) {
            undColour.add("GrayTighties");
            widget.prefs.setStringList('undeeColours', undColour);
            myUndees.add(Image.asset(
              'assets/images/grayTighties.png',
            ));
          }
          break;
        case 5:
          widget.prefs.setString('changeColor', "DarkBlueTighties");
          undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
          if (!undColour.contains("DarkBlueTighties")) {
            undColour.add("DarkBlueTighties");
            widget.prefs.setStringList('undeeColours', undColour);
            myUndees.add(Image.asset(
              'assets/images/blueTighties.png',
            ));
          }

          break;

        default:
      }
    });
  }

  List<Widget> myUndees = [];

  @override
  void initState() {
    super.initState();
    undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
    debugPrint(undeesStr);
    Image.asset(setUndees(widget.prefs));
    coins = widget.prefs.getInt('coins') ?? 0;
    undColour = widget.prefs.getStringList('undeeColours') ?? ["Pink"];
    debugPrint(undColour.toString());
    myUndees = getMyUndeesImages(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.lightGray,
            toolbarHeight: SizeConfig.blockSizeVertical * 8,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                  AppColors.backgroundColor,
                  AppColors.lightGray
                ]))),
            title: Text(
              "Change My Undees",
              style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: orientation == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal * 7
                      : SizeConfig.blockSizeVertical * 6),
            ),
          ),
          body: Consumer<Controller>(
            builder: (_, notifier, __) {
              return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.lightGray,
                          AppColors.backgroundColor
                        ]),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "My Undees",
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeHorizontal * 7
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Text(
                        "Default (Pink) and all purchased, current undees are outlined.",
                        style: TextStyle(
                          fontSize: notifier.isPhone
                              ? SizeConfig.blockSizeHorizontal * 4
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal * 3
                                  : SizeConfig.blockSizeVertical * 3,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        height: orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 10
                            : SizeConfig.blockSizeVertical * 8,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 2)),
                        child: ListView.builder(
                            itemCount: myUndees.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: undeesStr == undColour[index]
                                      ? Border.all(
                                          color: AppColors.darkBlue, width: 2)
                                      : Border.all(
                                          color: Colors.transparent, width: 2),
                                  //
                                ),
                                height: SizeConfig.blockSizeVertical * 30,
                                width: SizeConfig.blockSizeHorizontal * 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectUndees(index);
                                        });
                                      },
                                      child: myUndees[index]),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "Available Styles and Colours",
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeHorizontal * 7
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Text(
                        "100 coins each",
                        style: TextStyle(
                          fontSize: notifier.isPhone
                              ? SizeConfig.blockSizeHorizontal * 4
                              : orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal * 3
                                  : SizeConfig.blockSizeVertical * 3,
                        ),
                      ),
                      Flexible(
                        flex: orientation == Orientation.portrait ? 3 : 2,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          child: GridView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    debugPrint(index.toString());
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Buy these for 100 coins?",
                                              style: TextStyle(
                                                fontSize: notifier.isPhone
                                                    ? SizeConfig
                                                            .blockSizeHorizontal *
                                                        4
                                                    : orientation ==
                                                            Orientation.portrait
                                                        ? SizeConfig
                                                                .blockSizeHorizontal *
                                                            3
                                                        : SizeConfig
                                                                .blockSizeVertical *
                                                            3,
                                              ),
                                            ),
                                            content: coins > 100
                                                ? images[index]
                                                : Text(
                                                    "You don't have enough coins! Keep playing to win more.",
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
                                                  ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: coins >= 100
                                                      ? () {
                                                          coins = coins - 100;
                                                          widget.prefs.setInt(
                                                              'coins', coins);
                                                          selectUndees(index);
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (c,
                                                                      a1, a2) =>
                                                                  ChangeUndees(
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
                                                  child: coins >= 100
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
                                  },
                                  child: Container(
                                    //
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: AppColors.darkBlue, width: 2),
                                      //
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: images[index],
                                    ),
                                  ));
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 4, //horizontal space
                                    crossAxisSpacing: 4, //vertical space
                                    crossAxisCount:
                                        orientation == Orientation.portrait
                                            ? 3
                                            : 6,
                                    childAspectRatio:
                                        notifier.isPhone ? 1.75 : 2),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Container(
                              height: SizeConfig.blockSizeVertical * 8,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/BasketOfCoins.png"),
                                // fit: BoxFit.scaleDown,
                              )),
                              child: Center(
                                  child: Text(
                                coins.toString(),
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 6,
                                ),
                              ))),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, top: 8.0),
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
                  ));
            },
          ),
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
