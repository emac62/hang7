import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/banner_ad_widget.dart';
import 'package:hang7/widgets/check_remaining_words.dart';
import 'package:hang7/widgets/size_config.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUndees extends StatefulWidget {
  const ChangeUndees({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeUndees> createState() => _ChangeUndeesState();
}

class _ChangeUndeesState extends State<ChangeUndees> {
  late String undeesStr;
  late List<String> undColour;
  List<String> availableUndees = [];
  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  int coins = 0;

  final undeesScrollController = ScrollController();
  final ItemScrollController myUndeesPostitionedController =
      ItemScrollController();
  final ItemPositionsListener myUndeesPositionsListener =
      ItemPositionsListener.create();

  List<String> allUndees = [
    "Pink",
    "GreenPlaid",
    "White",
    "DarkBlue",
    "WhiteTighties",
    "GrayTighties",
    "DarkBlueTighties",
    "TealBrief",
    "PurpleBrief",
    "SunsetBrief",
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
    Image.asset(
      'assets/images/tealBrief.png',
    ),
    Image.asset(
      'assets/images/purpleBrief.png',
    ),
    Image.asset(
      'assets/images/sunsetBrief.png',
    ),
  ];

  selectUndees(int index) {
    var setProv = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      setProv.setGameUndees(availableUndees[index]);
      undeesStr = setProv.gameUndees;

      if (!undColour.contains(availableUndees[index])) {
        undColour.add(availableUndees[index]);
        setProv.setUndeeColours(undColour);
        myUndees.add(availableUndeeImages[index]);
      }
    });
  }

  List<Widget> myUndees = [];
  late SharedPreferences prefs;
  getSPInstance(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    undeesStr = settingsProvider.gameUndees;

    // Image.asset(setUndees(prefs)); doesn't equal anything
    coins = settingsProvider.coins;
    undColour = settingsProvider.undeeColours as List<String>;
    availableUndees =
        allUndees.where((element) => !undColour.contains(element)).toList();

    myUndees = getMyUndeesImages(undColour);
    getAvailableUndeeImages();
  }

  @override
  void initState() {
    super.initState();
    getSPInstance(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      myUndeesPostitionedController.scrollTo(
          index: undColour.indexOf(undeesStr),
          duration: const Duration(microseconds: 250));
    });
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
        case "TealBrief":
          availableUndeeImages.add(Image.asset("assets/images/tealBrief.png"));
          break;
        case "PurpleBrief":
          availableUndeeImages
              .add(Image.asset("assets/images/purpleBrief.png"));
          break;
        case "SunsetBrief":
          availableUndeeImages
              .add(Image.asset("assets/images/sunsetBrief.png"));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.backgroundColor, AppColors.lightGray])),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.lightGray,
              toolbarHeight: orientation == Orientation.portrait
                  ? SizeConfig.blockSizeVertical * 6
                  : SizeConfig.blockSizeVertical * 5,
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                    AppColors.lightGray,
                    AppColors.backgroundColor,
                  ]))),
              title: Text(
                "Change My Undees",
                style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 3.5
                        : SizeConfig.blockSizeVertical * 4),
              ),
            ),
            body: Consumer<Controller>(
              builder: (_, notifier, __) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
                        child: Text(
                          "My Undees",
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                      ),
                      Text(
                        "Current Undees are highlighted.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 2)),
                        height: orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 12
                            : SizeConfig.blockSizeVertical * 10,
                        alignment: Alignment.center,
                        child: ScrollablePositionedList.builder(
                            itemCount: myUndees.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemScrollController: myUndeesPostitionedController,
                            itemPositionsListener: myUndeesPositionsListener,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Card(
                                  color: AppColors.backgroundColor,
                                  elevation: 8,
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: undeesStr == undColour[index]
                                        ? const BorderSide(
                                            color: AppColors.darkBlue, width: 4)
                                        : const BorderSide(
                                            color: Colors.transparent,
                                            width: 2),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              settingsProvider.setGameUndees(
                                                  undColour[index]);

                                              undeesStr =
                                                  settingsProvider.gameUndees;
                                            });
                                          },
                                          child: myUndees[index]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Available Styles and Colours",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                      ),
                      Text(
                        "Purchase for 100 coins each.",
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2,
                        ),
                      ),
                      Container(
                        height: orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 12
                            : SizeConfig.blockSizeVertical * 10,
                        alignment: Alignment.center,
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
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Card(
                                    color: AppColors.backgroundColor,
                                    elevation: 8,
                                    child: GestureDetector(
                                        onTap: () {
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
                                                  content: coins >= 100
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
                                                                settingsProvider
                                                                    .setCoins(
                                                                        coins);
                                                                selectUndees(
                                                                    index);

                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (c,
                                                                            a1,
                                                                            a2) =>
                                                                        const ChangeUndees(),
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
                                          //
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppColors.darkBlue,
                                                width: 1),
                                            //
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: availableUndeeImages[index],
                                          ),
                                        )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You have",
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 4
                                    : SizeConfig.blockSizeVertical * 3,
                              ),
                            ),
                            Container(
                                height: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 8
                                    : SizeConfig.blockSizeVertical * 6,
                                width: SizeConfig.blockSizeHorizontal * 40,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/BasketOfCoins.png"),
                                  fit: BoxFit.scaleDown,
                                )),
                                child: Center(
                                  child: Text(
                                    "$coins",
                                    style: TextStyle(
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeVertical * 4
                                          : SizeConfig.blockSizeVertical * 3,
                                    ),
                                  ),
                                )),
                            Text(
                              "coins!",
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 4
                                    : SizeConfig.blockSizeVertical * 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
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
                                          : SizeConfig.blockSizeVertical * 1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    SlideLeftRoute(page: const Options()));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 3),
                                child: Text(
                                  "Back to Options",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.5),
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
                                          : SizeConfig.blockSizeVertical * 1,
                                ),
                              ),
                              onPressed: () {
                                checkRemainingWords(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 3),
                                child: Text(
                                  "Play",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar:
                (context.select((SettingsProvider sp) => sp.removeAds))
                    ? Container(
                        color: AppColors.lightGray,
                        height: 10,
                      )
                    : bannerAdContainer,
          ),
        ),
      );
    });
  }
}
