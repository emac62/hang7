import 'package:flutter/material.dart';

import '../providers/controller.dart';
import 'size_config.dart';

class BasketCount extends StatelessWidget {
  const BasketCount({
    Key? key,
    required this.coins,
    required this.orientation,
    required this.notifier,
  }) : super(key: key);

  final int coins;
  final Orientation orientation;
  final Controller notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: orientation == Orientation.portrait
              ? SizeConfig.blockSizeVertical * 3
              : SizeConfig.blockSizeVertical * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have",
            style: TextStyle(
              fontSize: notifier.isPhone
                  ? SizeConfig.blockSizeHorizontal * 5
                  : orientation == Orientation.portrait
                      ? SizeConfig.blockSizeVertical * 2.5
                      : SizeConfig.isSmallHeight
                          ? SizeConfig.blockSizeVertical * 4
                          : SizeConfig.blockSizeVertical * 3,
            ),
          ),
          Container(
              height: orientation == Orientation.portrait
                  ? SizeConfig.blockSizeVertical * 8
                  : SizeConfig.isSmallHeight
                      ? SizeConfig.blockSizeVertical * 8
                      : SizeConfig.blockSizeVertical * 7,
              width: notifier.isPhone
                  ? SizeConfig.blockSizeHorizontal * 25
                  : SizeConfig.isSmallHeight
                      ? SizeConfig.blockSizeHorizontal * 20
                      : SizeConfig.blockSizeHorizontal * 15,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                opacity: 0.75,
                image: AssetImage("assets/images/BasketOfCoins.png"),
                fit: BoxFit.scaleDown,
              )),
              child: Center(
                child: Text(
                  "$coins",
                  style: TextStyle(
                    fontSize: notifier.isPhone
                        ? SizeConfig.blockSizeHorizontal * 6.5
                        : orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 2.5
                            : SizeConfig.isSmallHeight
                                ? SizeConfig.blockSizeVertical * 4.5
                                : SizeConfig.blockSizeVertical * 3,
                  ),
                ),
              )),
          Text(
            "coins!",
            style: TextStyle(
              fontSize: notifier.isPhone
                  ? SizeConfig.blockSizeHorizontal * 5
                  : orientation == Orientation.portrait
                      ? SizeConfig.blockSizeVertical * 2.5
                      : SizeConfig.isSmallHeight
                          ? SizeConfig.blockSizeVertical * 4
                          : SizeConfig.blockSizeVertical * 3,
            ),
          ),
        ],
      ),
    );
  }
}
