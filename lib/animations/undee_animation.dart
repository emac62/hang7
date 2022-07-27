import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UndeeAnimation extends StatefulWidget {
  const UndeeAnimation({
    Key? key,
    required this.duration,
    required this.selected,
    required this.fromLeft,
    required this.imgSize,
    required this.orientation,
    required this.prefs,
  }) : super(key: key);
  final int duration;
  final bool selected;
  final double fromLeft;
  final Orientation orientation;
  final SharedPreferences prefs;

  final double imgSize;

  @override
  State<UndeeAnimation> createState() => _UndeeAnimationState();
}

class _UndeeAnimationState extends State<UndeeAnimation> {
  double onLine = 0;
  late Image undeeImage;
  bool withAnimation = true;

  @override
  void initState() {
    super.initState();
    undeeImage = Image.asset(setUndees(widget.prefs));
    withAnimation = widget.prefs.getBool('withAnimation') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Controller>(
      builder: (_, notifier, __) {
        return withAnimation
            ? AnimatedPositioned(
                width: widget.selected ? widget.imgSize : 0,
                top: widget.selected
                    ? notifier.isPhone
                        ? SizeConfig.screenWidth * 0.155 //phone on line
                        : widget.orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical *
                                6 //tablet portrait on line
                            : SizeConfig.blockSizeVertical *
                                8 // tablet landscape on line
                    : widget.orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical * 25
                        : SizeConfig.blockSizeVertical *
                            30, //starting position from top
                left: widget.selected
                    ? widget.fromLeft
                    : notifier.isPhone
                        ? SizeConfig.blockSizeHorizontal *
                            80 //phone from starting from left
                        : widget.orientation == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal *
                                60 // tablet portrait from left
                            : SizeConfig.blockSizeHorizontal *
                                50, // tablet landscape starting from left
                duration: Duration(milliseconds: widget.duration),
                curve: Curves.bounceOut,
                child: undeeImage)
            : Positioned(
                width: widget.selected ? widget.imgSize : 0,
                top: widget.selected
                    ? notifier.isPhone
                        ? SizeConfig.blockSizeVertical * 7.5
                        : widget.orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 6
                            : SizeConfig.blockSizeVertical * 9
                    : SizeConfig.blockSizeVertical * 20,
                left: widget.selected
                    ? widget.fromLeft
                    : notifier.isTablet
                        ? SizeConfig.blockSizeHorizontal * 75
                        : SizeConfig.blockSizeHorizontal * 85,
                child: undeeImage);
      },
    );
  }
}
