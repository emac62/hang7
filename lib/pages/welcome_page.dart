import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/help.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/controller.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int? coins;
  bool withAnimation = true;
  // List<String> wp3 = [
  //   '0',
  //   "1",
  //   "2",
  //   "3",
  //   "4",
  //   "5",
  //   "6",
  //   "7",
  //   "8",
  //   "9",
  //   "10",
  //   "11",
  //   "12",
  //   "13",
  //   "14",
  //   "15",
  //   "16",
  //   "17",
  //   "18",
  //   "19",
  //   "20",
  //   "21",
  //   "22",
  //   "23",
  //   "24",
  //   "25",
  //   "26",
  //   "27",
  //   "28",
  //   "29",
  //   "30",
  //   "31",
  //   "32",
  //   "33",
  //   "34",
  //   "35",
  //   "36",
  //   "37",
  //   "38",
  //   "39",
  //   "40",
  //   "41",
  //   "42",
  //   "43",
  //   "44",
  //   "45",
  //   "46",
  //   "47",
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false).getDevice();
    });
    setState(() {
      coins = (widget.prefs.getInt('coins') ?? 0);
      withAnimation = widget.prefs.getBool('withAnimation') ?? true;
      final wordpack = widget.prefs.getString('wordPack') ??
          widget.prefs.setString('wordPack', "WordPack 1");
      debugPrint(wordpack.toString());
      // widget.prefs.setStringList('usedWords3', wp3);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.backgroundColor, AppColors.lightGray]),
                image: orientation == Orientation.portrait
                    ? const DecorationImage(
                        image: AssetImage('assets/images/tabletPortBG.png'),
                        fit: BoxFit.cover)
                    : const DecorationImage(
                        image: AssetImage('assets/images/tabletLandBG.png'),
                        fit: BoxFit.cover),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 600 ||
                      constraints.maxHeight < 675) {
                    return portLayout();
                  } else {
                    return landLayout();
                  }
                },
              ));
        },
      ),
    );
  }

  Widget portLayout() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
            width: SizeConfig.blockSizeHorizontal * 90,
            child: Image.asset(
              'assets/images/wpGraphic.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "_______",
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: 10,
                fontSize: SizeConfig.blockSizeHorizontal * 18),
          ),
        ),
        Expanded(
          flex: 1,
          child:
              Text("Figure out the 7 letter word without hanging your UnDees!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 6,
                    letterSpacing: 2,
                    fontFamily: "Boogaloo",
                  )),
        ),
        Expanded(
          flex: 3,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 35),
                  child: Image.asset(
                    'assets/images/fullBasket.png',
                    width: SizeConfig.safeBlockHorizontal * 50,
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.darkBlue,
                        blurRadius: 10.0,
                        offset: Offset(-5, -5))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.lightGray,
                        AppColors.green,
                      ])),
              width: SizeConfig.blockSizeHorizontal * 45,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          withAnimation
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
                        child: Text(
                          "Play",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Boogaloo",
                              fontSize: SizeConfig.blockSizeHorizontal * 7),
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          debugPrint("Stats pressed");
                          showDialog(
                              context: context,
                              builder: (_) => GameStatsAlert(
                                    coins: coins ?? 0,
                                    orientation: Orientation.portrait,
                                  ));
                        },
                        child: Text(
                          "Stats",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Boogaloo",
                              fontSize: SizeConfig.blockSizeHorizontal * 7),
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          withAnimation
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
                        child: Text(
                          "Options",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Boogaloo",
                              fontSize: SizeConfig.blockSizeHorizontal * 7),
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          showAboutDialog(
                              context: context,
                              applicationIcon: Image.asset(
                                'assets/images/seven.png',
                                height: 60,
                                width: 60,
                              ),
                              applicationName: "Hang7",
                              applicationVersion: "1.0.0",
                              applicationLegalese: '©2022 borderlineBoomer',
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(children: [
                                      Text(
                                        'Guess the word without hanging your UnDees!',
                                        style: TextStyle(
                                            fontFamily: "Boogaloo",
                                            color: AppColors.darkBlue,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    8),
                                      ),
                                    ]))
                              ]);
                        },
                        child: Text(
                          "About",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Boogaloo",
                              fontSize: SizeConfig.blockSizeHorizontal * 7),
                        )),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          showHelpDialog(context);
                        },
                        child: Text(
                          "Help",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: "Boogaloo",
                              fontSize: SizeConfig.blockSizeHorizontal * 7),
                        )),
                  ],
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  OrientationBuilder landLayout() {
    return OrientationBuilder(builder: (context, orientation) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 2.5),
            child: SizedBox(
                height: orientation == Orientation.portrait ? 300 : 250,
                child: orientation == Orientation.portrait
                    ? Image.asset(
                        'assets/images/wpGraphic.png',
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset(
                        'assets/images/wpGraphic.png',
                        fit: BoxFit.fitHeight,
                      )),
          ),
          // ,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: orientation == Orientation.portrait ? 2 : 5,
                  child: Padding(
                    padding: orientation == Orientation.portrait
                        ? EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 2)
                        : EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeVertical * 5),
                          child: Text(
                            "_______",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 12,
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 10
                                    : SizeConfig.blockSizeHorizontal * 5),
                          ),
                        ),
                        Text(
                          "Figure out the word without",
                          style: TextStyle(
                              letterSpacing: 5,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal * 4
                                  : SizeConfig.blockSizeHorizontal * 3),
                        ),
                        Text(
                          "hanging your UnDees!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              letterSpacing: 5,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal * 4
                                  : SizeConfig.blockSizeHorizontal * 3),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  top: SizeConfig.blockSizeHorizontal * 20)
                              : EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 5),
                          child: Image.asset(
                            'assets/images/fullBasket.png',
                            width: orientation == Orientation.portrait
                                ? SizeConfig.safeBlockVertical * 33
                                : SizeConfig.safeBlockHorizontal * 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: orientation == Orientation.portrait ? 1 : 3,
                  child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.darkBlue,
                              blurRadius: 10.0,
                              offset: Offset(-5, -5))
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.lightGray,
                              AppColors.green,
                            ])),
                    width: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal * 40
                        : SizeConfig.blockSizeHorizontal * 25,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                withAnimation
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
                              child: Text(
                                "Play",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontFamily: "Boogaloo",
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeHorizontal * 4),
                              )),
                          TextButton(
                              onPressed: () {
                                debugPrint("Stats pressed");
                                showDialog(
                                    context: context,
                                    builder: (_) => GameStatsAlert(
                                          coins: coins ?? 0,
                                          orientation: Orientation.portrait,
                                        ));
                              },
                              child: Text(
                                "Stats",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontFamily: "Boogaloo",
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeHorizontal * 4),
                              )),
                          TextButton(
                              onPressed: () {
                                withAnimation
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
                              child: Text(
                                "Options",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontFamily: "Boogaloo",
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeHorizontal * 4),
                              )),
                          TextButton(
                              onPressed: () {
                                showAboutDialog(
                                    context: context,
                                    applicationIcon: Image.asset(
                                      'assets/images/seven.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    applicationName: "Hang 7",
                                    applicationVersion: "1.0.0",
                                    applicationLegalese:
                                        '©2022 borderlineBoomer',
                                    children: <Widget>[
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Column(children: [
                                            Text(
                                              'Guess the word without hanging your UnDees!',
                                              style: TextStyle(
                                                  fontFamily: "Boogaloo",
                                                  color: AppColors.darkBlue,
                                                  fontSize: orientation ==
                                                          Orientation.portrait
                                                      ? SizeConfig
                                                              .blockSizeHorizontal *
                                                          4.5
                                                      : SizeConfig
                                                              .blockSizeHorizontal *
                                                          3),
                                            ),
                                          ]))
                                    ]);
                              },
                              child: Text(
                                "About",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontFamily: "Boogaloo",
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeHorizontal * 4),
                              )),
                          TextButton(
                              onPressed: () {
                                showHelpDialog(context);
                              },
                              child: Text(
                                "Help",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontFamily: "Boogaloo",
                                    fontSize: orientation ==
                                            Orientation.portrait
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeHorizontal * 4),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
