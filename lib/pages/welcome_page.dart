import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/help.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/check_remaining_words.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import '../providers/controller.dart';
import '../providers/unique_word.dart';
import '../widgets/txt_btn.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late int coins;
  bool withAnimation = true;
  bool isPhone = false;
  bool isTablet = false;

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Provider.of<UniqueWord>(context, listen: false).loadUsedWordsIndexes();
    var controller = Provider.of<Controller>(context);
    if (controller.isPhone) {
      isPhone = true;
    } else {
      isTablet = true;
      isPhone = false;
    }
    var settingsProvider = Provider.of<SettingsProvider>(context);
    coins = settingsProvider.coins;
    withAnimation = settingsProvider.withAnimation;

    return Scaffold(
      body: OrientationBuilder(builder: ((context, orientation) {
        return Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [AppColors.backgroundColor, AppColors.lightGray]),
            image: isPhone
                ? const DecorationImage(
                    image: AssetImage('assets/images/phoneGrass.png'),
                    fit: BoxFit.cover)
                : orientation == Orientation.portrait
                    ? const DecorationImage(
                        image: AssetImage('assets/images/tabPortGrass.png'),
                        fit: BoxFit.cover)
                    : const DecorationImage(
                        image: AssetImage('assets/images/tabLandGrass.png'),
                        fit: BoxFit.cover),
          ),
          child: Column(children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 30,
            ),
            Text(
              "_______",
              style: TextStyle(
                  letterSpacing: isPhone ? 9 : 12,
                  fontSize: isPhone
                      ? SizeConfig.blockSizeHorizontal * 9
                      : orientation == Orientation.portrait
                          ? SizeConfig.blockSizeVertical * 7
                          : SizeConfig.blockSizeVertical * 7),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Figure out",
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 5,
                                letterSpacing: 1,
                                fontFamily: "Boogaloo",
                              )),
                          Text("the 7 letter word",
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 5,
                                letterSpacing: 1,
                                fontFamily: "Boogaloo",
                              )),
                          Text("without hanging",
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 5,
                                letterSpacing: 1,
                                fontFamily: "Boogaloo",
                              )),
                          Text("a week of Undees!",
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 3
                                    : SizeConfig.blockSizeVertical * 5,
                                letterSpacing: 1,
                                fontFamily: "Boogaloo",
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomRight,
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
                        width: SizeConfig.blockSizeHorizontal * 35,
                        // height: orientation == Orientation.portrait
                        //     ? SizeConfig.blockSizeVertical * 45
                        //     : SizeConfig.blockSizeVertical * 65,
                        child: MainMenuBtns(
                          coins: coins,
                          withAnimation: withAnimation,
                          isPhone: isPhone,
                          orientation: orientation,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        );
      })),
    );
  }
}

class MainMenuBtns extends StatefulWidget {
  const MainMenuBtns({
    Key? key,
    required this.coins,
    required this.withAnimation,
    required this.isPhone,
    required this.orientation,
  }) : super(key: key);

  final int coins;
  final bool withAnimation;
  final Orientation orientation;
  final bool isPhone;

  @override
  State<MainMenuBtns> createState() => _MainMenuBtnsState();
}

class _MainMenuBtnsState extends State<MainMenuBtns> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.orientation == Orientation.portrait
          ? EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 5)
          : EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextBtn(
            text: "Play",
            ontap: () {
              checkRemainingWords(context);
            },
            isPhone: widget.isPhone,
            orientation: widget.orientation,
          ),
          TextBtn(
            text: "Stats",
            ontap: () {
              debugPrint("stats");
              // Navigator.push(context, FadeRoute(page: const Options()));
              showDialog(
                  context: context,
                  builder: (_) => GameStatsAlert(
                        coins: widget.coins,
                        orientation: Orientation.portrait,
                      ));
            },
            isPhone: widget.isPhone,
            orientation: widget.orientation,
          ),
          TextBtn(
            text: "Options",
            ontap: () {
              widget.withAnimation
                  ? Navigator.push(
                      context, RotationRoute(page: const Options()))
                  : Navigator.push(context, FadeRoute(page: const Options()));
            },
            isPhone: widget.isPhone,
            orientation: widget.orientation,
          ),
          TextBtn(
            text: "About",
            ontap: () {
              showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/images/seven.png',
                    height: 60,
                    width: 60,
                  ),
                  applicationName: "Hang7",
                  applicationVersion: "1.1.0",
                  applicationLegalese: '©2022 borderlineBoomer',
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Text(
                            'Guess the word without hanging your Undees!',
                            style: TextStyle(
                                fontFamily: "Boogaloo",
                                color: AppColors.darkBlue,
                                fontSize: SizeConfig.blockSizeVertical * 4),
                          ),
                        ]))
                  ]);
            },
            isPhone: widget.isPhone,
            orientation: widget.orientation,
          ),
          TextBtn(
            text: "Help",
            ontap: () {
              showHelpDialog(context);
            },
            isPhone: widget.isPhone,
            orientation: widget.orientation,
          )
        ],
      ),
    );
  }
}
