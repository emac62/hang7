import 'package:flutter/material.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';

class KeyboardRow extends StatelessWidget {
  const KeyboardRow(
      {Key? key,
      required this.min,
      required this.max,
      required this.orientation})
      : super(key: key);

  final int min;
  final int max;
  final Orientation orientation;

  @override
  Widget build(BuildContext context) {
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
                                Provider.of<Controller>(context, listen: false)
                                    .onUserInput(letter: e.key);
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
