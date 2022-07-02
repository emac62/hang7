import 'package:flutter/material.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';

showHelpDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => OrientationBuilder(
            builder: (context, orientation) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: AppColors.lightGray,
                title: Text(
                  "How to Play",
                  style: TextStyle(
                      fontFamily: "Boogaloo",
                      color: AppColors.darkBlue,
                      letterSpacing: 1.25,
                      fontSize: SizeConfig.blockSizeVertical * 5),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Guess the 7 letter word without hanging all your UnDees! There are 7 UnDees in the basket. ",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 4.5
                              : SizeConfig.blockSizeHorizontal * 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Each _ represents a letter in the word. Choose a letter from the keyboard. If the letter is in the word, it will be replace the _ in the word. If it is not in the word, 1 pair of UnDees will be hung on the clothes line for all to see! Solve the word before you run out.",
                        style: TextStyle(
                            letterSpacing: 1.25,
                            color: AppColors.darkBlue,
                            fontSize: orientation == Orientation.portrait
                                ? SizeConfig.blockSizeHorizontal * 4.5
                                : SizeConfig.blockSizeHorizontal * 3),
                      ),
                    ),
                    Text(
                      "10 coins are awarded for each win. 1 coin is awarded for every undee left in the basket. Regardless of winning, 10 bonus points are awarded for playing your 25th, 50th, 75th and 100th games.",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 4.5
                              : SizeConfig.blockSizeHorizontal * 3),
                    ),
                    Text(
                      "In the future, coins will be able to purchase various styles of undees and different word packs.",
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: AppColors.darkBlue,
                          fontSize: orientation == Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal * 4.5
                              : SizeConfig.blockSizeHorizontal * 3),
                    )
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
