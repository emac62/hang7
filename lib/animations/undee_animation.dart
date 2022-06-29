import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
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

  setUndees() {
    String pickedColor = widget.prefs.getString('changeColor') ?? "Pink";
    debugPrint("pickedColor: $pickedColor");
    setState(() {
      switch (pickedColor) {
        case "Pink":
          undeeImage = Image.asset("assets/images/pinkUndees.png");
          break;
        case "White":
          undeeImage = Image.asset("assets/images/whiteUndees.png");
          break;
        case "DarkBlue":
          undeeImage = Image.asset("assets/images/blueUndees.png");
          break;
        default:
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setUndees();
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
            child: undeeImage);
      },
    );
  }
}
