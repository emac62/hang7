import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';

class LetterTile extends StatefulWidget {
  const LetterTile({Key? key, required this.index, required this.orientation})
      : super(key: key);
  final int index;
  final Orientation orientation;
  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool isPhone;
  late bool isTablet;
  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _fontColor = AppColors.darkBlue;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Consumer<Controller>(builder: (_, notifier, __) {
      String text = "";
      text = notifier.separatedBlankWord[widget.index];
      if (notifier.gameCompleted && !notifier.gameWon) {
        _fontColor = AppColors.redish;
      }
      if (text != "_") {
        if (mounted) {
          _animationController.forward();
        }
      }
      if (notifier.isPhone) {
        isPhone = true;
        isTablet = false;
      } else {
        isPhone = false;
        isTablet = true;
      }

      return settingsProvider.withWordAnimation
          ? AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                double flip = 0;
                if (_animationController.value > 0.5) {
                  flip = pi;
                }
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_animationController.value * pi)
                    ..rotateX(flip),
                  child: Container(
                    width: notifier.isPhone
                        ? SizeConfig.blockSizeHorizontal * 12
                        : widget.orientation == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal * 12
                            : SizeConfig.blockSizeHorizontal * 6,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1.5),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Boogaloo",
                            color: _fontColor,
                            fontSize: isPhone
                                ? SizeConfig.blockSizeVertical * 7
                                : widget.orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeVertical * 9
                                    : SizeConfig.screenHeight < 740
                                        ? SizeConfig.blockSizeVertical * 5
                                        : SizeConfig.blockSizeVertical * 7),
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              width: notifier.isPhone
                  ? SizeConfig.blockSizeHorizontal * 12
                  : widget.orientation == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal * 12
                      : SizeConfig.blockSizeHorizontal * 6,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 2)),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Boogaloo",
                    color: _fontColor,
                    fontSize: isPhone
                        ? SizeConfig.blockSizeVertical * 7
                        : widget.orientation == Orientation.portrait
                            ? SizeConfig.blockSizeVertical * 9
                            : SizeConfig.screenHeight < 600
                                ? SizeConfig.blockSizeVertical * 5
                                : SizeConfig.blockSizeVertical * 7),
              ),
            );
    });
  }
}
