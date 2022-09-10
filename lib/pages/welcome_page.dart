import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/help.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/check_remaining_words.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';

import '../providers/controller.dart';
import '../providers/unique_word.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int? coins;
  bool withAnimation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false).getDevice();
    });
    checkWordPack();
  }

  checkWordPack() async {
    var myWordPacks = [];

    myWordPacks =
        Provider.of<SettingsProvider>(context, listen: false).myWordPacks;
    debugPrint("myWordPacks: $myWordPacks");
    if (myWordPacks[0] == "Word Pack 1") {
      myWordPacks[0] = "WordPack 1";
      Provider.of<SettingsProvider>(context, listen: false)
          .setMyWordPacks(myWordPacks);
    }
    debugPrint("myWordPacks: $myWordPacks");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Provider.of<UniqueWord>(context, listen: false).loadUsedWordsIndexes();
    var settingsProvider = Provider.of<SettingsProvider>(context);
    coins = settingsProvider.coins;
    withAnimation = settingsProvider.withAnimation;

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
                  if (constraints.maxWidth <= 600) {
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
                letterSpacing: 9,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          checkRemainingWords(context);
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
                                  context, RotationRoute(page: const Options()))
                              : Navigator.push(
                                  context, FadeRoute(page: const Options()));
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
    debugPrint("landLayout");
    // debugPrint("screenWidth: ${SizeConfig.screenWidth}");
    return OrientationBuilder(builder: (context, orientation) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 2.5),
            child: SizedBox(
                height: orientation == Orientation.portrait
                    ? 300
                    : SizeConfig.blockSizeVertical * 35,
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
                  flex: orientation == Orientation.portrait ? 2 : 6,
                  child: Padding(
                    padding: orientation == Orientation.portrait
                        ? EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5)
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
                                letterSpacing: 10,
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 5
                                    : SizeConfig.blockSizeVertical * 5),
                          ),
                        ),
                        Text(
                          "Guess the 7 letter word",
                          style: TextStyle(
                              letterSpacing:
                                  orientation == Orientation.portrait ? 2 : 3,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 3
                                  : SizeConfig.blockSizeVertical * 5),
                        ),
                        Text(
                          "before your basket",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              letterSpacing:
                                  orientation == Orientation.portrait ? 2 : 3,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 3
                                  : SizeConfig.blockSizeVertical * 5),
                        ),
                        Text(
                          "is empty!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              letterSpacing:
                                  orientation == Orientation.portrait ? 2 : 3,
                              fontFamily: "Boogaloo",
                              fontSize: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 3
                                  : SizeConfig.blockSizeVertical * 5),
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
                  flex: orientation == Orientation.portrait ? 1 : 2,
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
                                    ? Navigator.push(context,
                                        RotationRoute(page: const GameBoard()))
                                    : Navigator.push(context,
                                        FadeRoute(page: const GameBoard()));
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
                                    ? Navigator.push(context,
                                        RotationRoute(page: const Options()))
                                    : Navigator.push(context,
                                        FadeRoute(page: const Options()));
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
                                              'Guess the word without hanging out your Undees!',
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
