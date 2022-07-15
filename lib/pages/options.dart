import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/change_undees.dart';
import 'package:hang7/pages/change_words.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Options extends StatefulWidget {
  const Options({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool showAnimations = true;
  bool playSound = true;
  String wordGroup = "";

  late Image undeesImage;

  int? coins;
  bool withAnimations = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      coins = (widget.prefs.getInt('coins') ?? 0);
      undeesImage = Image.asset(setUndees(widget.prefs));
      wordGroup = (widget.prefs.getString('wordGroup')) ?? "Word Pack 1";
      withAnimations = (widget.prefs.getBool('withAnimations') ?? true);
    });
  }

  final Uri _url = Uri.parse('https://dailyquote.ca');

  Future<void> clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('gameStats');
    prefs.remove('chart');
  }

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.lightGray,
              toolbarHeight: SizeConfig.blockSizeVertical * 10,
              title: Text(
                "OPTIONS",
                style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal * 7
                        : SizeConfig.blockSizeVertical * 6),
              )),
          body: Consumer<Controller>(
            builder: (_, notifier, __) {
              return Container(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.lightGray, AppColors.backgroundColor]),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Play animations?',
                              style: TextStyle(
                                fontSize: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : SizeConfig.blockSizeVertical * 5,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 8,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Switch(
                                    activeColor: AppColors.green,
                                    inactiveThumbColor:
                                        AppColors.backgroundColor,
                                    value: settingsProvider.withAnimation,
                                    onChanged: (value) {
                                      setState(() {
                                        settingsProvider
                                            .setWithAnimation(value);
                                        if (value) {
                                          debugPrint("value $value");
                                        } else {}
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 2,
                        ),
                        child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeHorizontal * 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("My Current Undees:",
                                      style: TextStyle(
                                        fontSize: notifier.isPhone
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : SizeConfig.blockSizeVertical *
                                                    5,
                                      )),
                                  SizedBox(
                                      height: SizeConfig.blockSizeVertical * 6,
                                      child: undeesImage),
                                  Icon(
                                    Icons.arrow_right_outlined,
                                    color: AppColors.green,
                                    size: notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 8
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 5,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              settingsProvider.withAnimation
                                  ? Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: ChangeUndees(
                                        prefs: widget.prefs,
                                      )))
                                  : Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: ChangeUndees(
                                        prefs: widget.prefs,
                                      )));
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 2,
                        ),
                        child: GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.blockSizeHorizontal * 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Current Word Pack:",
                                      style: TextStyle(
                                        fontSize: notifier.isPhone
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : SizeConfig.blockSizeVertical *
                                                    5,
                                      )),
                                  Text(
                                      widget.prefs.getString('wordGroup') ??
                                          "Word Pack 1",
                                      style: TextStyle(
                                        fontSize: notifier.isPhone
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : SizeConfig.blockSizeVertical *
                                                    5,
                                      )),
                                  Icon(
                                    Icons.arrow_right_outlined,
                                    color: AppColors.green,
                                    size: notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 8
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 5,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              settingsProvider.withAnimation
                                  ? Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: ChangeWordPack(
                                        prefs: widget.prefs,
                                      )))
                                  : Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: ChangeWordPack(
                                        prefs: widget.prefs,
                                      )));
                            }),
                      ),
                      //
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reset Stats",
                                style: TextStyle(
                                  fontSize: notifier.isPhone
                                      ? SizeConfig.blockSizeHorizontal * 5
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : SizeConfig.blockSizeVertical * 5,
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.green,
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
                                  clearSP();
                                  showDialog(
                                      context: context,
                                      builder: (_) => GameStatsAlert(
                                            coins: coins ?? 0,
                                            orientation: Orientation.portrait,
                                          ));
                                },
                                child: Text("Reset Stats",
                                    style: TextStyle(
                                      fontSize: notifier.isPhone
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : orientation == Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  5
                                              : SizeConfig.blockSizeVertical *
                                                  5,
                                    )))
                          ],
                        ),
                      ),

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
                                          RotationRoute(
                                              page: WelcomePage(
                                            prefs: widget.prefs,
                                          )))
                                      : Navigator.push(
                                          context,
                                          FadeRoute(
                                              page: WelcomePage(
                                            prefs: widget.prefs,
                                          )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 3),
                                  child: Text(
                                    "Main Menu",
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: _launchUrl,
                          child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff182835),
                                image: const DecorationImage(
                                    image:
                                        AssetImage('assets/images/quotes.png'),
                                    fit: BoxFit.fitWidth),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: SizeConfig.blockSizeVertical * 7,
                              width: notifier.isPhone
                                  ? SizeConfig.blockSizeHorizontal * 95
                                  : orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 80
                                      : SizeConfig.blockSizeHorizontal * 60,
                              child: Center(
                                child: Text(
                                  "Try our online game Daily Quote",
                                  style: TextStyle(
                                      color: AppColors.lightGray,
                                      fontSize: orientation ==
                                              Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 4
                                          : SizeConfig.blockSizeHorizontal * 2),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: AppColors.violet,
                border: Border(
                    top: BorderSide(color: AppColors.darkBlue, width: 2))),
            height: 60,
          ),
        );
      },
    );
  }
}
