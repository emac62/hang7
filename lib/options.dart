import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool showAnimations = true;
  bool playSound = true;

  int? coins;

  void loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = (prefs.getInt('coins') ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();
    loadCoins();
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
              iconTheme: const IconThemeData(color: AppColors.darkBlue),
              backgroundColor: AppColors.backgroundColor,
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
                      colors: [AppColors.backgroundColor, AppColors.lightGray]),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '**Play animations?',
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
                                    activeColor: AppColors.darkBlue,
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
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('**Play sound effects? ',
                                style: TextStyle(
                                  fontSize: notifier.isPhone
                                      ? SizeConfig.blockSizeHorizontal * 5
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : SizeConfig.blockSizeVertical * 5,
                                )),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 8,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Switch(
                                    activeColor: AppColors.darkBlue,
                                    inactiveThumbColor:
                                        AppColors.backgroundColor,
                                    value: settingsProvider.withSound,
                                    onChanged: (value) {
                                      setState(() {
                                        settingsProvider.setWithSound(value);
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 12,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text('UnDees Colour:',
                                        style: TextStyle(
                                          fontSize: notifier.isPhone
                                              ? SizeConfig.blockSizeHorizontal *
                                                  5
                                              : orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeHorizontal *
                                                      5
                                                  : SizeConfig
                                                          .blockSizeVertical *
                                                      5,
                                        )),
                                  ),
                                  const Text(
                                      'Colour will not change during a game.')
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(12),
                                      primary: AppColors.darkBlue),
                                  child:
                                      settingsProvider.changeColor == "DarkBlue"
                                          ? const Text("✓")
                                          : null,
                                  onPressed: () {
                                    setState(() {
                                      settingsProvider
                                          .setChangeColor("DarkBlue");
                                    });
                                  }),
                            ),
                            Flexible(
                              flex: 1,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                    primary: Colors.white,
                                  ),
                                  child: settingsProvider.changeColor == "White"
                                      ? const Text(
                                          "✓",
                                          style: TextStyle(
                                              color: AppColors.darkBlue),
                                        )
                                      : null,
                                  onPressed: () {
                                    setState(() {
                                      settingsProvider.setChangeColor("White");
                                    });
                                  }),
                            ),
                            Flexible(
                              flex: 1,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                    primary: const Color(0xffEBA6C8),
                                  ),
                                  child: settingsProvider.changeColor == "Pink"
                                      ? const Text(
                                          "✓",
                                          style: TextStyle(
                                              color: AppColors.darkBlue),
                                        )
                                      : null,
                                  onPressed: () {
                                    setState(() {
                                      settingsProvider.setChangeColor("Pink");
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
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
                      const Text("** Features coming soon!")
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: Color(0xff182835),
                image: DecorationImage(
                    image: AssetImage('assets/images/quotes.png'),
                    fit: BoxFit.fitWidth),
                border: Border(
                    top: BorderSide(color: AppColors.darkBlue, width: 2))),
            height: 60,
            child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: _launchUrl,
                child: Text(
                  "Try our online game Daily Quote",
                  style: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
                )),
          ),
        );
      },
    );
  }
}
