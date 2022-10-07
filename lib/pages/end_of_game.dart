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
  bool withAnimation = true;

  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  void loadCoins() {
    var setProv = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      coins = setProv.coins;
      withAnimation = setProv.withAnimation;
    });
  }

  int gamesPlayed = 0;

  void getGamesPlayed() async {
    var prefs = await SharedPreferences.getInstance();
    var gameStats = prefs.getStringList('gameStats');
    gamesPlayed = int.parse(gameStats![0]);
  }

  @override
  void initState() {
    super.initState();
    loadCoins();
    winner = Provider.of<Controller>(context, listen: false).gameWon;
    getGamesPlayed();

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
                        child: winner
                            ? Text(
                                '${widget.coinsEarned} Coins Won!',
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                            : Text(
                                "YOU GOT A ",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              ),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: SizeConfig.blockSizeVertical * 8,
                        child: !winner
                            ? Image.asset(
                                "assets/images/wedgie.png",
                                fit: BoxFit.fitHeight,
                              )
                            : settings.withWordAnimation
                                ? const CoinSpinAnimation()
                                : Image.asset(
                                    'assets/images/BasketOfCoins.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                      )),
                      Expanded(
                        child: winner
                            ? Text(
                                "$coins Coins in the Basket",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              )
                            : Text(
                                "Better luck next game!",
                                style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 6
                                      : SizeConfig.blockSizeVertical * 4,
                                ),
                              ),
                      ),
                      Text(
                        'STATISTICS',
                        style: TextStyle(
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 6
                              : SizeConfig.blockSizeVertical * 4,
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
                                  withAnimation
                                      ? Navigator.pushReplacement(context,
                                          SlideRoute(page: const Options()))
                                      : Navigator.pushReplacement(context,
                                          FadeRoute(page: const Options()));
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
                                  if (gamesPlayed % 2 == 0) {
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
}
