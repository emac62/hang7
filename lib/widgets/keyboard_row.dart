import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/end_of_game.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import '../animations/route.dart';
import 'app_colors.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow({
    Key? key,
    required this.min,
    required this.max,
    required this.orientation,
  }) : super(key: key);

  final int min;
  final int max;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    late bool isPhone;
    return Consumer<Controller>(
      builder: (_, notifier, __) {
        if (notifier.isPhone) {
          isPhone = true;
        } else {
          isPhone = false;
        }
        int index = 0;
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: keysMap.entries.map((e) {
              index++;
              if (index >= min && index <= max) {
                Color fontColor = AppColors.lightGray;
                Color backgroundColor = AppColors.greenGray;
                if (e.value == KeyState.contains) {
                  fontColor = AppColors.lightGray;
                  backgroundColor = AppColors.darkBlue;
                } else if (e.value == KeyState.selected) {
                  fontColor = AppColors.lightGray;
                  backgroundColor = Colors.transparent;
                }
                return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 1,
                        vertical: SizeConfig.blockSizeVertical * 0.25),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        child: Material(
                            color: backgroundColor,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                (e.value == KeyState.selected ||
                                        e.value == KeyState.contains)
                                    ? null
                                    : Provider.of<Controller>(context,
                                            listen: false)
                                        .onUserInput(letter: e.key);
                                if (notifier.gameCompleted &&
                                    !notifier.gameWon) {
                                  Future.delayed(
                                      const Duration(milliseconds: 7000), () {
                                    settingsProvider.withAnimation
                                        ? Navigator.push(
                                            context,
                                            RotationRoute(
                                                page: const EndOfGame(
                                              coinsEarned: 0,
                                            )))
                                        : Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: const EndOfGame(
                                              coinsEarned: 0,
                                            )));
                                  });
                                }
                                if (notifier.gameWon) {
                                  debugPrint("keyInput: Game Won");
                                  int coins = settingsProvider.coins;
                                  coins =
                                      coins + 10 + notifier.remainingGuesses;
                                  settingsProvider.setCoins(coins);

                                  Future.delayed(
                                      const Duration(milliseconds: 4000), () {
                                    settingsProvider.withAnimation
                                        ? Navigator.push(
                                            context,
                                            RotationRoute(
                                                page: EndOfGame(
                                              coinsEarned: (10 +
                                                  notifier.remainingGuesses),
                                            )))
                                        : Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: EndOfGame(
                                              coinsEarned: (10 +
                                                  notifier.remainingGuesses),
                                            )));
                                  });
                                }
                              },
                              child: Center(
                                child: Padding(
                                  padding: isPhone
                                      ? EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.blockSizeHorizontal *
                                                  2.5,
                                          vertical:
                                              SizeConfig.blockSizeVertical *
                                                  0.75)
                                      : orientation == Orientation.portrait
                                          ? EdgeInsets.all(
                                              SizeConfig.blockSizeHorizontal *
                                                  1.5)
                                          : EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.blockSizeVertical *
                                                      2,
                                              vertical:
                                                  SizeConfig.blockSizeVertical *
                                                      0.5),
                                  child: Text(
                                    e.key,
                                    style: TextStyle(
                                      fontFamily: "Boogaloo",
                                      color: fontColor,
                                      fontSize: isPhone
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : orientation == Orientation.portrait
                                              ? SizeConfig.blockSizeHorizontal *
                                                  5
                                              : SizeConfig.blockSizeVertical *
                                                  4,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ));
              } else {
                return const SizedBox();
              }
            }).toList());
      },
    );
  }
}
