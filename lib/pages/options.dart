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

import '../widgets/ad_helper.dart';
import '../widgets/paywall_widget.dart';

class Options extends StatefulWidget {
  const Options({
    Key? key,
  }) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late Image undeesImage = Image.asset('assets/images/pinkUndees.png');

  int coins = 0;

  bool withWordAnimation = true;
  bool withBGSound = true;

  late SharedPreferences sharedPrefs;

  BannerAdContainer bannerAdContainer = const BannerAdContainer();
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    getSPInstance().then((_) {
      setState(() {
        var setProv = Provider.of<SettingsProvider>(context, listen: false);
        coins = setProv.coins;
        undeesImage = Image.asset(setUndees(context));
        withBGSound = setProv.withBGSound;
        withWordAnimation = setProv.withWordAnimation;
      });
    });
    //
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: useTestAds
            ? AdHelper.testInterstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            debugPrint("adReady: $_isInterstitialAdReady");
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Failed to Load Interstitial Ad ${error.message}");
        }));
  }

  @override
  void didChangeDependencies() {
    loadInterstitialAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('gameStats');
    prefs.remove('chart');
  }

  getSPInstance() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var controller = Provider.of<Controller>(context);
    debugPrint("isSmall: ${SizeConfig.screenHeight}");
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                AppColors.lightGray,
                AppColors.backgroundColor,
              ])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.lightGray,
                toolbarHeight: controller.isPhone
                    ? SizeConfig.blockSizeVertical * 6
                    : orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 8
                        : SizeConfig.blockSizeVertical * 5,
                flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                      AppColors.backgroundColor,
                      AppColors.lightGray,
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
                return SafeArea(
                  child: Padding(
                    padding: notifier.isPhone
                        ? EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeVertical * 2)
                        : orientation == Orientation.portrait
                            ? EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 5)
                            : EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OptionName(
                              notifier: notifier,
                              orientation: orientation,
                              name: "Play word animation?",
                            ),
                            Switch(
                                activeColor: AppColors.green,
                                inactiveThumbColor: AppColors.backgroundColor,
                                value: settingsProvider.withWordAnimation,
                                onChanged: (value) {
                                  setState(() {
                                    settingsProvider
                                        .setWithWordAnimation(value);
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OptionName(
                                notifier: notifier,
                                orientation: orientation,
                                name: 'Play sound effects?'),
                            Switch(
                                activeColor: AppColors.green,
                                inactiveThumbColor: AppColors.backgroundColor,
                                value: settingsProvider.withSound,
                                onChanged: (value) {
                                  setState(() {
                                    settingsProvider.setWithSound(value);
                                  });
                                }),
                          ],
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2)
                              : EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OptionName(
                                  notifier: notifier,
                                  orientation: orientation,
                                  name: "Reset Stats?"),
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
                                      border: Border.all(
                                          color: AppColors.lightGray),
                                      color: AppColors.green),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 4),
                                      child: BtnName(
                                          isPhone: notifier.isPhone,
                                          orientation: orientation,
                                          name: "Reset")),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2)
                              : EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1),
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
                                    OptionName(
                                        notifier: notifier,
                                        orientation: orientation,
                                        name: "My Current Undees:"),
                                    SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 5,
                                        child: undeesImage),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.lightGray),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.green),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 4),
                                          child: BtnName(
                                            isPhone: notifier.isPhone,
                                            name: "Change",
                                            orientation: orientation,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    SlideRightRoute(
                                        page: const ChangeUndees()));
                              }),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2)
                              : EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1),
                          child: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeHorizontal * 1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OptionName(
                                        notifier: notifier,
                                        orientation: orientation,
                                        name: "Current WordPack:"),
                                    OptionName(
                                        notifier: notifier,
                                        orientation: orientation,
                                        name: settingsProvider.wordPack),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppColors.lightGray),
                                          color: AppColors.green),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 4),
                                          child: BtnName(
                                              isPhone: notifier.isPhone,
                                              orientation: orientation,
                                              name: "Change")),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    SlideRightRoute(
                                        page: const ChangeWordPack()));
                              }),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 2)
                              : EdgeInsets.symmetric(
                                  vertical: SizeConfig.blockSizeVertical * 1),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OptionName(
                                            notifier: notifier,
                                            orientation: orientation,
                                            name: "Need more coins?"),
                                        OptionName(
                                            notifier: notifier,
                                            orientation: orientation,
                                            name: "Hide advertisements?"),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.lightGray),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppColors.green),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 4),
                                          child: BtnName(
                                              isPhone: notifier.isPhone,
                                              orientation: orientation,
                                              name: "Purchase Options")),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                fetchOffers(context);
                              }),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: AppColors.lightGray),
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 10,
                                  padding: EdgeInsets.all(
                                    notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 2
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 2
                                            : SizeConfig.blockSizeVertical *
                                                1.5,
                                  ),
                                ),
                                onPressed: () {
                                  (context.select((SettingsProvider sp) =>
                                          sp.removeAds))
                                      ? null
                                      : _isInterstitialAdReady
                                          ? _interstitialAd?.show()
                                          : null;

                                  Navigator.pushReplacement(context,
                                      FadeRoute(page: const WelcomePage()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 3),
                                  child: BtnName(
                                    isPhone: notifier.isPhone,
                                    orientation: orientation,
                                    name: "Main Menu",
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: AppColors.lightGray),
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 10,
                                  padding: EdgeInsets.all(
                                    notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 2
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 2
                                            : SizeConfig.blockSizeVertical *
                                                1.5,
                                  ),
                                ),
                                onPressed: () {
                                  checkRemainingWords(context);
                                },
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 3),
                                    child: BtnName(
                                        isPhone: notifier.isPhone,
                                        orientation: orientation,
                                        name: "Play")),
                              ),
                            ],
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
                      if (!context.mounted) return;
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
                  if (!context.mounted) return;
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

class BtnName extends StatelessWidget {
  const BtnName({
    Key? key,
    required this.orientation,
    required this.name,
    required this.isPhone,
  }) : super(key: key);
  final Orientation orientation;
  final String name;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        color: AppColors.lightGray,
        fontSize: isPhone
            ? SizeConfig.blockSizeVertical * 2
            : orientation == Orientation.portrait
                ? SizeConfig.blockSizeVertical * 3
                : SizeConfig.isSmallHeight
                    ? SizeConfig.blockSizeVertical * 3.5
                    : SizeConfig.blockSizeVertical * 3,
      ),
    );
  }
}

class OptionName extends StatelessWidget {
  const OptionName({
    Key? key,
    required this.notifier,
    required this.orientation,
    required this.name,
  }) : super(key: key);
  final Controller notifier;
  final Orientation orientation;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontSize: notifier.isPhone
            ? SizeConfig.blockSizeHorizontal * 5
            : orientation == Orientation.portrait
                ? SizeConfig.blockSizeVertical * 3
                : SizeConfig.isSmallHeight
                    ? SizeConfig.blockSizeVertical * 4
                    : SizeConfig.blockSizeVertical * 3,
      ),
    );
  }
}
