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
  double fromTopPhoneStart = 0;
  double fromTopPhoneEnd = 0;
  double fromTopTablet = 0;
  late Image undeeImage;

  @override
  void initState() {
    super.initState();
    undeeImage = Image.asset(setUndees(widget.prefs));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Controller>(
      builder: (_, notifier, __) {
        return AnimatedPositioned(
            width: widget.selected ? widget.imgSize : 0,
            top: widget.selected
                ? notifier.isPhone
                    ? SizeConfig.blockSizeVertical * 9.5
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
            child: undeeImage);
      },
    );
  }
}
