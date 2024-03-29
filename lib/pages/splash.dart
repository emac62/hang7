import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image wedgieImg;

  @override
  void initState() {
    super.initState();
    wedgieImg = Image.asset('assets/images/wedgie.png');

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, FadeRoute(page: const WelcomePage()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(wedgieImg.image, context);
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
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 50,
                  child: Image(
                    image: wedgieImg.image,
                    fit: orientation == Orientation.portrait
                        ? BoxFit.fitWidth
                        : BoxFit.fitHeight,
                  ),
                  //
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
