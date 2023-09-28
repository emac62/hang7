import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hang7/animations/coin_spin.dart';
import 'package:hang7/animations/route.dart';

import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/main.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/banner_ad_widget.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/stats_bar_chart.dart';
import 'package:hang7/widgets/stats_row.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/ad_helper.dart';
import '../widgets/check_remaining_words.dart';

class EndOfGame extends StatefulWidget {
  const EndOfGame({
    Key? key,
    required this.coinsEarned,
  }) : super(key: key);
  final int coinsEarned;

  @override
  State<EndOfGame> createState() => _EndOfGameState();
}

class _EndOfGameState extends State<EndOfGame> {
  late bool winner;
  int? coins;

  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  void loadCoins() {
    var setProv = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      coins = setProv.coins;
    });
  }

  int gamesPlayed = 0;
  int winStreak = 0;

  getGamesPlayed() async {
    var prefs = await SharedPreferences.getInstance();
    var gameStats = prefs.getStringList('gameStats');
    gamesPlayed = int.parse(gameStats![0]);
    winStreak = int.parse(gameStats[3]);
  }

  final RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: "rateMyApp_",
      appStoreIdentifier: 'com.blB.hang7',
      googlePlayIdentifier: 'com.blB.hang7',
      minDays: 3,
      minLaunches: 5,
      remindDays: 7,
      remindLaunches: 10);

  @override
  void initState() {
    super.initState();

    loadCoins();
    winner = Provider.of<Controller>(context, listen: false).gameWon;
    getGamesPlayed();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();

      if (mounted && rateMyApp.shouldOpenDialog && winStreak > 2) {
        rateMyApp.showStarRateDialog(
          context,
          title: "Enjoying Hang7?",
          message: "Please consider leaving a rating.",
          starRatingOptions: const StarRatingOptions(initialRating: 4),
          dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20)),
          actionsBuilder: (context, stars) {
            return [
              RateMyAppNoButton(rateMyApp, text: "CANCEL"),
              TextButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanks for your feedback!')),
                  );
                  final launchAppStore = stars! >= 4;

                  const event = RateMyAppEventType.rateButtonPressed;

                  await rateMyApp.callEvent(event);

                  if (launchAppStore) {
                    rateMyApp.launchStore();
                  }
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ];
          },
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });

    InterstitialAd.load(
        adUnitId: useTestAds
            ? AdHelper.testInterstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Failed to Load Interstitial Ad ${error.message}");
        })); //
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Controller, SettingsProvider>(
        builder: (context, notifier, settings, __) {
      return OrientationBuilder(
        builder: ((context, orientation) {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF66B8FE), AppColors.lightGray])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                minimum: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeHorizontal * 2),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: winner
                              ? Column(
                                  children: [
                                    Text(
                                      '${widget.coinsEarned} coins won',
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                      ),
                                    ),
                                    settings.withWordAnimation
                                        ? SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    10,
                                            child:
                                                CoinSpinAnimation(coins: coins))
                                        : Container(
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    10,
                                            width: double.infinity,
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
                                                  fontSize: SizeConfig
                                                          .blockSizeVertical *
                                                      6,
                                                ),
                                              ),
                                            )),
                                    Text(
                                      "for a total of $coins in the basket!",
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "YOU GOT A ",
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/wedgie.png",
                                      height: SizeConfig.blockSizeVertical * 10,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Text(
                                      "Better luck next game!",
                                      style: TextStyle(
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 6
                                            : SizeConfig.blockSizeVertical * 4,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2),
                        child: Text(
                          'STATISTICS',
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 6
                                : SizeConfig.blockSizeVertical * 4,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.transparent, width: 2)),
                          child: StatsRow(
                            orientation: orientation,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: orientation == Orientation.portrait ? 4 : 4,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.transparent, width: 2)),
                            child: StatsBarChart(
                              orientation: orientation,
                            ),
                          )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                ),
                                onPressed: () {
                                  keysMap.updateAll((key, value) =>
                                      value = KeyState.unselected);

                                  notifier.resetGame();
                                  Navigator.pushReplacement(context,
                                      SlideRoute(page: const Options()));
                                },
                                child: Text(
                                  'Options',
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                ),
                                onPressed: () {
                                  if (gamesPlayed % 8 == 0) {
                                    SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersive,
                                    );

                                    if (_isInterstitialAdReady) {
                                      _interstitialAd.show();
                                    }
                                  }

                                  checkRemainingWords(context);
                                },
                                child: Text(
                                  'New Game',
                                  style: TextStyle(
                                    fontSize:
                                        orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 4,
                                  ),
                                )),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
              bottomNavigationBar:
                  (context.select((SettingsProvider sp) => sp.removeAds))
                      ? null
                      : bannerAdContainer,
            ),
          );
        }),
      );
    });
  }

  List<Widget> actionsBuilder(BuildContext context, double? stars) =>
      stars == null
          ? [buildCancelButton()]
          : [buildOkButton(stars), buildCancelButton()];

  Widget buildOkButton(double stars) => TextButton(
        child: const Text('OK'),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks for your feedback!')),
          );

          final launchAppStore = stars >= 4;

          const event = RateMyAppEventType.rateButtonPressed;

          await rateMyApp.callEvent(event);

          if (launchAppStore) {
            rateMyApp.launchStore();
          }

          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );

  Widget buildCancelButton() => RateMyAppNoButton(
        rateMyApp,
        text: 'CANCEL',
      );
}
