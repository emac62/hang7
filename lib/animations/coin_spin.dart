import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CoinSpinAnimation extends StatefulWidget {
  const CoinSpinAnimation({
    Key? key,
  }) : super(key: key);

  @override
  State<CoinSpinAnimation> createState() => _CoinSpinAnimationState();
}

class _CoinSpinAnimationState extends State<CoinSpinAnimation>
    with SingleTickerProviderStateMixin {
  bool isFront = true;
  double degrees = 0;
  bool showCoinBasket = false;

  late Timer _timer;

  Widget frontSide() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.transparent),
        key: const Key('front'),
        child: Image.asset('assets/images/Coin.png'));
  }

  Widget backSide() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.transparent),
        key: const Key('back'),
        child: Image.asset('assets/images/Coin2.png'));
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (mounted) {
          setState(() {
            if (timer.tick >= 46) {
              timer.cancel();
              showCoinBasket = true;
            }
          });
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    degrees = degrees + 15;
    if (degrees >= 360) degrees = 0;
    if (degrees <= 90 || degrees >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
    final angle = degrees * (pi / 180);
    return showCoinBasket
        ? Image.asset('assets/images/BasketOfCoins.png')
        : Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? frontSide()
                : Transform(
                    transform: Matrix4.identity()..rotateY(angle),
                    alignment: Alignment.center,
                    child: backSide()));
  }
}
