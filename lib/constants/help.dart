import 'package:flutter/material.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';

showHelpDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => OrientationBuilder(
            builder: (context, orientation) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: AppColors.lightGray,
                title: Text(
                  "How to Play",
                  style: TextStyle(
                      fontFamily: "Boogaloo",
                      color: AppColors.darkBlue,
                      letterSpacing: 1.25,
                      fontSize: SizeConfig.blockSizeVertical * 4),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guess the 7 letter word!",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          fontFamily: 'Roboto',
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 1.5
                              : SizeConfig.blockSizeVertical * 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Choose a letter from the keyboard. If the letter is in the hidden word, it will be revealed on the game board. If it is not in the word, 1 pair of 'Undees' will move from the basket to the clothesline! Solve the puzzle before you run out.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.5
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "There are 7 pairs of 'Undees' in the basket at the start of the game.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.5
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "10 coins are awarded for each win plus 1 coin for every pair of Undees left in the basket.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.5
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Text(
                      "10 bonus coins are awarded for every 25 games you finish.",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          fontFamily: 'Roboto',
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 1.5
                              : SizeConfig.blockSizeVertical * 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Use your coins to change the style of Undees or get new Word Packs.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.5
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Everyone starts with 'Pink Undees' and 50 words in Work Pack 1! Add more colours or styles to your basket for 100 coins each. Get new Words for 500 coins or use the same words again for 100 coins.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.5
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontFamily: "Boogaloo",
                            color: AppColors.darkBlue,
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            letterSpacing: 1.25),
                      ))
                ],
              );
            },
          ));
}
