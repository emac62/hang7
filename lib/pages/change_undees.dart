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
  List<String> availableUndees = [];

  late int coins;

  final myUndeesScrollController = ScrollController();
  final undeesScrollController = ScrollController();

  List<String> allUndees = [
    "Pink",
    "GreenPlaid",
    "White",
    "DarkBlue",
    "DarkBlueTighties",
    "WhiteTighties",
    "GrayTighties"
  ];

  List<Widget> images = [
    Image.asset(
      'assets/images/pinkUndees.png',
    ),
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
      widget.prefs.setString('changeColor', availableUndees[index]);
      undeesStr = widget.prefs.getString('changeColor') ?? "Pink";
      if (!undColour.contains(availableUndees[index])) {
        undColour.add(availableUndees[index]);
        widget.prefs.setStringList('undeeColours', undColour);
        myUndees.add(availableUndeeImages[index]);
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
    availableUndees =
        allUndees.where((element) => !undColour.contains(element)).toList();
    debugPrint(undColour.toString());
    myUndees = getMyUndeesImages(widget.prefs);
    getAvailableUndeeImages();
  }

  List<Widget> availableUndeeImages = [];

  getAvailableUndeeImages() {
    for (var i = 0; i < availableUndees.length; i++) {
      switch (availableUndees[i]) {
        case "GreenPlaid":
          availableUndeeImages.add(Image.asset("assets/images/greenPlaid.png"));
          break;
        case "White":
          availableUndeeImages
              .add(Image.asset("assets/images/whiteUndees.png"));
          break;
        case "DarkBlue":
          availableUndeeImages.add(Image.asset("assets/images/blueUndees.png"));
          break;
        case "DarkBlueTighties":
          availableUndeeImages
              .add(Image.asset("assets/images/blueTighties.png"));
          break;
        case "WhiteTighties":
          availableUndeeImages
              .add(Image.asset("assets/images/whiteTighties.png"));
          break;
        case "GrayTighties":
          availableUndeeImages
              .add(Image.asset("assets/images/grayTighties.png"));
          break;
      }
    }
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 1),
                          child: Text(
                            "My Undees",
                            style: TextStyle(
                              fontSize: notifier.isPhone
                                  ? SizeConfig.blockSizeVertical * 4
                                  : orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeVertical * 5
                                      : SizeConfig.blockSizeVertical * 4,
                            ),
                          ),
                        ),
                        Text(
                          "Default (Pink) and all purchased.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeVertical * 2
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 3,
                          ),
                        ),
                        Text(
                          "Current UnDees are outlined.",
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
                              border: Border.all(
                                  color: Colors.transparent, width: 2)),
                          height: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 12
                              : SizeConfig.blockSizeVertical * 12,
                          alignment: Alignment.center,
                          child: Scrollbar(
                            controller: myUndeesScrollController,
                            thumbVisibility: true,
                            thickness: 3,
                            child: ListView.builder(
                                itemCount: myUndees.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                controller: myUndeesScrollController,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: undeesStr == undColour[index]
                                          ? Border.all(
                                              color: AppColors.darkBlue,
                                              width: 2)
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                widget.prefs.setString(
                                                    'changeColor',
                                                    undColour[index]);
                                                undeesStr = widget.prefs
                                                        .getString(
                                                            'changeColor') ??
                                                    "Pink";
                                              });
                                            },
                                            child: myUndees[index]),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Available Styles and Colours",
                            style: TextStyle(
                              fontSize: notifier.isPhone
                                  ? SizeConfig.blockSizeVertical * 4
                                  : orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeVertical * 5
                                      : SizeConfig.blockSizeVertical * 4,
                            ),
                          ),
                        ),
                        Text(
                          "Purchase for 100 coins each",
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeVertical * 2
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 3,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 15,
                          child: Scrollbar(
                            controller: undeesScrollController,
                            thumbVisibility: true,
                            thickness: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: undeesScrollController,
                                itemCount: availableUndeeImages.length,
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
                                                content: coins > 100
                                                    ? availableUndeeImages[
                                                        index]
                                                    : Text(
                                                        "You don't have enough coins! Keep playing to win more.",
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
                                                      ),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: coins >= 100
                                                          ? () {
                                                              coins =
                                                                  coins - 100;
                                                              widget.prefs
                                                                  .setInt(
                                                                      'coins',
                                                                      coins);
                                                              selectUndees(
                                                                  index);
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (c,
                                                                          a1,
                                                                          a2) =>
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
                                                                        ? SizeConfig.blockSizeHorizontal *
                                                                            3
                                                                        : SizeConfig.blockSizeVertical *
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
                                                                        ? SizeConfig.blockSizeHorizontal *
                                                                            3
                                                                        : SizeConfig.blockSizeVertical *
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
                                        //
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppColors.darkBlue,
                                              width: 2),
                                          //
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: availableUndeeImages[index],
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 5),
                            height: SizeConfig.blockSizeVertical * 8,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage("assets/images/BasketOfCoins.png"),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    padding: EdgeInsets.all(
                                      notifier.isPhone
                                          ? SizeConfig.blockSizeHorizontal * 2
                                          : orientation == Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  2
                                              : SizeConfig.blockSizeVertical *
                                                  1,
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
                                              SizeConfig.blockSizeVertical *
                                                  2.5),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 10,
                                    padding: EdgeInsets.all(
                                      notifier.isPhone
                                          ? SizeConfig.blockSizeHorizontal * 2
                                          : orientation == Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  2
                                              : SizeConfig.blockSizeVertical *
                                                  1,
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
                                              SizeConfig.blockSizeVertical *
                                                  2.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
