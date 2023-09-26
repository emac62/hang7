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
                      "Guess the 7 letter word without hanging all your Undees! There are 7 Undees in the basket at the start of each game. ",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          fontFamily: 'Roboto',
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 1.75
                              : SizeConfig.blockSizeVertical * 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Each underscore ( _ ) represents a letter in the word. Choose a letter from the keyboard. If the letter(s) is in the word, it will replace the underscore on the game board. If it is not in the word, 1 pair of Undees will move to the clothesline for all to see! Solve the puzzle before you run out.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.75
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Purchase various styles of Undees and new Word Packs with coins won during play.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.75
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
                                ? SizeConfig.blockSizeVertical * 1.75
                                : SizeConfig.blockSizeVertical * 3),
                      ),
                    ),
                    Text(
                      "Regardless of winning, 10 bonus coins are awarded for every 25 games you finish.",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          fontFamily: 'Roboto',
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeVertical * 1.75
                              : SizeConfig.blockSizeVertical * 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Each Word Pack contains 50 words. Once used, they will need to be refreshed for 100 coins or you can buy a new Word Pack for 500 coins.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: 'Roboto',
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeVertical * 1.75
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
