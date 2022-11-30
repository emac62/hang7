import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/main.dart';
import 'package:hang7/pages/change_undees.dart';
import 'package:hang7/pages/change_words.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/banner_ad_widget.dart';
import 'package:hang7/widgets/check_remaining_words.dart';
import 'package:hang7/widgets/game_stats_alert.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/ad_helper.dart';
import '../widgets/paywall_widget.dart';

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late Image undeesImage = Image.asset('assets/images/pinkUndees.png');

  int coins = 0;
  bool withAnimations = true;
  bool withWordAnimation = true;

  late SharedPreferences sharedPrefs;

  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    getSPInstance().then((_) {
      setState(() {
        var setProv = Provider.of<SettingsProvider>(context, listen: false);
        coins = setProv.coins;
        undeesImage = Image.asset(setUndees(context));
        withAnimations = setProv.withAnimation;
        withWordAnimation = setProv.withWordAnimation;
      });
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

  final Uri _url = Uri.parse('https://dailyquote.ca');

  Future<void> clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('gameStats');
    prefs.remove('chart');
  }

  getSPInstance() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var controller = Provider.of<Controller>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.backgroundColor, AppColors.lightGray])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.lightGray,
                toolbarHeight: controller.isPhone
                    ? SizeConfig.blockSizeVertical * 6
                    : orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 8
                        : SizeConfig.blockSizeVertical * 7,
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
                  "OPTIONS",
                  style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: controller.isPhone
                          ? SizeConfig.blockSizeVertical * 4
                          : orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 5
                              : SizeConfig.blockSizeVertical * 4),
                )),
            body: Consumer<Controller>(
              builder: (_, notifier, __) {
                return Padding(
                  padding: notifier.isPhone
                      ? EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeVertical * 2)
                      : orientation == Orientation.portrait
                          ? EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 10)
                          : EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Play word animations?',
                              style: TextStyle(
                                fontSize: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : SizeConfig.blockSizeVertical * 3,
                              ),
                            ),
                            SizedBox(
                              height: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 8
                                  : SizeConfig.blockSizeVertical * 5,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Switch(
                                    activeColor: AppColors.green,
                                    inactiveThumbColor:
                                        AppColors.backgroundColor,
                                    value: settingsProvider.withWordAnimation,
                                    onChanged: (value) {
                                      setState(() {
                                        settingsProvider
                                            .setWithWordAnimation(value);
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Play page transition animations?',
                              style: TextStyle(
                                fontSize: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : SizeConfig.blockSizeVertical * 3,
                              ),
                            ),
                            SizedBox(
                              height: orientation == Orientation.portrait
                                  ? SizeConfig.blockSizeVertical * 8
                                  : SizeConfig.blockSizeVertical * 5,
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
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2)
                              : const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Reset Stats?",
                                  style: TextStyle(
                                    fontSize: notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 3,
                                  )),
                              GestureDetector(
                                onTap: (() {
                                  clearSP();
                                  showDialog(
                                      context: context,
                                      builder: (_) => GameStatsAlert(
                                            coins: settingsProvider.coins,
                                            orientation: Orientation.portrait,
                                          ));
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.green),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4),
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(
                                        color: AppColors.lightGray,
                                        fontSize: notifier.isPhone
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : orientation ==
                                                    Orientation.portrait
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    4
                                                : SizeConfig.blockSizeVertical *
                                                    2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "You have ${settingsProvider.coins} Coins!",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.5),
                        ),
                        Text(
                          "100 needed to make changes.",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 1,
                          ),
                          child: GestureDetector(
                              child: Padding(
                                padding: orientation == Orientation.portrait
                                    ? EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.blockSizeVertical * 1)
                                    : const EdgeInsets.all(0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("My Current Undees:",
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
                                                      3,
                                        )),
                                    SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 5,
                                        child: undeesImage),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.green),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: AppColors.lightGray,
                                            fontSize: notifier.isPhone
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeHorizontal *
                                                        4
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                settingsProvider.withAnimation
                                    ? Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: const ChangeUndees()))
                                    : Navigator.push(context,
                                        FadeRoute(page: const ChangeUndees()));
                              }),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1.5)
                              : const EdgeInsets.all(0),
                          child: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeHorizontal * 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Current WordPack:",
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
                                                      3,
                                        )),
                                    Text(settingsProvider.wordPack,
                                        style: TextStyle(
                                          fontSize: notifier.isPhone
                                              ? SizeConfig.blockSizeHorizontal *
                                                  4
                                              : orientation ==
                                                      Orientation.portrait
                                                  ? SizeConfig
                                                          .blockSizeHorizontal *
                                                      4
                                                  : SizeConfig
                                                          .blockSizeVertical *
                                                      2.5,
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.green),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4),
                                        child: Text(
                                          "Change",
                                          style: TextStyle(
                                            color: AppColors.lightGray,
                                            fontSize: notifier.isPhone
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeHorizontal *
                                                        4
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                settingsProvider.withAnimation
                                    ? Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: const ChangeWordPack()))
                                    : Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: const ChangeWordPack()));
                              }),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1.5)
                              : const EdgeInsets.all(0),
                          child: GestureDetector(
                              child: Padding(
                                padding: orientation == Orientation.portrait
                                    ? EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.blockSizeVertical * 1)
                                    : const EdgeInsets.all(0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Need more coins?",
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
                                                      3,
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.green),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 4),
                                        child: Text(
                                          "See Purchase Options",
                                          style: TextStyle(
                                            color: AppColors.lightGray,
                                            fontSize: notifier.isPhone
                                                ? SizeConfig
                                                        .blockSizeHorizontal *
                                                    5
                                                : orientation ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeHorizontal *
                                                        4
                                                    : SizeConfig
                                                            .blockSizeVertical *
                                                        2,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                fetchOffers(context);
                              }),
                        ),
                        Center(
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
                                  (context.select((SettingsProvider sp) =>
                                          sp.removeAds))
                                      ? null
                                      : _isInterstitialAdReady
                                          ? _interstitialAd.show()
                                          : null;

                                  settingsProvider.withAnimation
                                      ? Navigator.push(
                                          context,
                                          RotationRoute(
                                              page: const WelcomePage()))
                                      : Navigator.push(context,
                                          FadeRoute(page: const WelcomePage()));
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
                                            SizeConfig.blockSizeVertical * 3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: _launchUrl,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff182834),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/quotes.png'),
                                      fit: BoxFit.contain),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: SizeConfig.blockSizeVertical * 7,
                                width: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 95
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 80
                                        : SizeConfig.blockSizeHorizontal * 50,
                                child: Center(
                                  child: Text(
                                    "Try our online game Daily Quote",
                                    style: TextStyle(
                                        color: AppColors.lightGray,
                                        fontSize: orientation ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 4
                                            : SizeConfig.blockSizeHorizontal *
                                                2),
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
            bottomNavigationBar:
                (context.select((SettingsProvider sp) => sp.removeAds))
                    ? null
                    : bannerAdContainer,
          ),
        );
      },
    );
  }

  Future fetchOffers(context) async {
    final offerings = await Purchases.getOfferings();

    if (offerings.current == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No Options Found")));
    } else {
      final packages = offerings.current!.availablePackages;
      if (!mounted) return;
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          context: context,
          builder: (context) => PaywallWidget(
                packages: packages,
                title: 'Purchase Options',
                description: '',
                onClickedPackage: (package) async {
                  try {
                    CustomerInfo customerInfo =
                        await Purchases.purchasePackage(package);

                    final pkg = package.storeProduct.title;

                    if (customerInfo.entitlements.all['no_ads']!.isActive) {
                      if (!mounted) return;
                      removeAds(context);
                    }

                    setState(() {
                      switch (pkg) {
                        case "100 Coins":
                          if (!mounted) break;
                          add100Coins(context);
                          break;
                        case "100 Coins (Hang 7)":
                          if (!mounted) break;
                          add100Coins(context);
                          break;
                        case "250 Coins":
                          if (!mounted) break;
                          add250Coins(context);
                          break;
                        case "250 Coins (Hang 7)":
                          if (!mounted) break;
                          add250Coins(context);
                          break;

                        default:
                      }
                    });
                  } catch (e) {
                    debugPrint("Failed to purchase product. $e");
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ));
    }
  }

  void add100Coins(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    settingsProvider.setCoins(settingsProvider.coins + 100);
  }

  void add250Coins(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.setCoins(settingsProvider.coins + 250);
  }

  void removeAds(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.setRemoveAds(true);
  }
}
