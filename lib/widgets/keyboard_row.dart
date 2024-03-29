import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/pages/end_of_game.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/utils/game_sounds.dart';
import 'package:hang7/widgets/size_config.dart';

import 'package:provider/provider.dart';

import '../animations/route.dart';

import 'app_colors.dart';

class KeyboardRow extends StatefulWidget {
  const KeyboardRow({
    Key? key,
    required this.min,
    required this.max,
    required this.orientation,
    required this.ontap,
  }) : super(key: key);

  final int min;
  final int max;
  final Orientation orientation;
  final VoidCallback ontap;

  @override
  State<KeyboardRow> createState() => _KeyboardRowState();
}

class _KeyboardRowState extends State<KeyboardRow> {
  var gameSounds = GameSounds();
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
              if (index >= widget.min && index <= widget.max) {
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
                                gameSounds.stopGameSound();
                                if (e.value == KeyState.unselected) {
                                  HapticFeedback.lightImpact();
                                  (e.value == KeyState.selected ||
                                          e.value == KeyState.contains)
                                      ? null
                                      : Provider.of<Controller>(context,
                                              listen: false)
                                          .onUserInput(letter: e.key);
                                  widget.ontap();

                                  if (notifier.gameCompleted &&
                                      !notifier.gameWon) {
                                    notifier.revealWord();
                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      // notifier.revealWord();
                                      settingsProvider.withSound
                                          ? gameSounds.playWedgieSound()
                                          : null;
                                    });
                                  }
                                  if (notifier.gameCompleted &&
                                      !notifier.gameWon) {
                                    Future.delayed(
                                        const Duration(milliseconds: 5000), () {
                                      Navigator.pushReplacement(
                                          context,
                                          FadeRoute(
                                              page: const EndOfGame(
                                                  coinsEarned: 0)));
                                    });
                                  }
                                  if (notifier.gameWon) {
                                    int coins = settingsProvider.coins;
                                    coins =
                                        coins + 10 + notifier.remainingGuesses;
                                    settingsProvider.setCoins(coins);
                                    settingsProvider.withSound
                                        ? Future.delayed(
                                            const Duration(milliseconds: 1500),
                                            () {
                                            gameSounds.playWinningSound();
                                          })
                                        : null;
                                    Future.delayed(
                                        const Duration(milliseconds: 3500), () {
                                      Navigator.pushReplacement(
                                          context,
                                          FadeRoute(
                                              page: EndOfGame(
                                            coinsEarned: (10 +
                                                notifier.remainingGuesses),
                                          )));
                                    });
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            content: const Text(
                                                'You have already selected this letter, choose another one.'),
                                            actions: <Widget>[
                                              IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                            ],
                                          ));
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
                                      : widget.orientation ==
                                              Orientation.portrait
                                          ? EdgeInsets.all(
                                              SizeConfig.blockSizeHorizontal *
                                                  1.5)
                                          : EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.blockSizeVertical *
                                                      2,
                                              vertical:
                                                  SizeConfig.blockSizeVertical *
                                                      0.25),
                                  child: Text(
                                    e.key,
                                    style: TextStyle(
                                      fontFamily: "Boogaloo",
                                      color: fontColor,
                                      fontSize: isPhone
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : widget.orientation ==
                                                  Orientation.portrait
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
