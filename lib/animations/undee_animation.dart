import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';

class UndeeAnimation extends StatefulWidget {
  const UndeeAnimation(
      {Key? key,
      required this.duration,
      required this.selected,
      required this.fromLeft,
      required this.imgSize,
      required this.orientation})
      : super(key: key);
  final int duration;
  final bool selected;
  final double fromLeft;
  final Orientation orientation;

  final double imgSize;

  @override
  State<UndeeAnimation> createState() => _UndeeAnimationState();
}

class _UndeeAnimationState extends State<UndeeAnimation> {
  double fromTopPhoneStart = 0;
  double fromTopPhoneEnd = 0;
  double fromTopTablet = 0;

  getClothesLinePositionStart() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Controller>(
      builder: (_, notifier, __) {
        return AnimatedPositioned(
            width: widget.selected ? widget.imgSize : 0,
            top: widget.selected
                ? notifier.isPhone
                    ? SizeConfig.blockSizeVertical * 8
                    : widget.orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 6
                        : SizeConfig.blockSizeVertical * 9
                : SizeConfig.blockSizeVertical * 20,
            left: widget.selected
                ? widget.fromLeft
                : notifier.isTablet
                    ? SizeConfig.blockSizeHorizontal * 75
                    : SizeConfig.blockSizeHorizontal * 85,
            duration: Duration(milliseconds: widget.duration),
            curve: Curves.bounceOut,
            child: Image.asset("assets/images/undees.png"));
      },
    );
  }
}
