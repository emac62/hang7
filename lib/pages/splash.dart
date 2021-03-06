import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final bool withAnimation = widget.prefs.getBool('withAnimation') ?? true;
    Timer(const Duration(seconds: 2), () {
      withAnimation
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
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Material(
          child: Container(
            height: SizeConfig.safeBlockVertical * 100,
            width: SizeConfig.safeBlockHorizontal * 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.backgroundColor, AppColors.green])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Don't get a",
                    style: TextStyle(
                        fontFamily: "Boogaloo",
                        fontSize: orientation == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal * 20
                            : SizeConfig.blockSizeVertical * 10,
                        color: AppColors.darkBlue),
                  ),
                ),
                Image.asset('assets/images/wedgie.png'),
              ],
            ),
          ),
        );
      },
    );
  }
}
