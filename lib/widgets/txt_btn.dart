import 'package:flutter/material.dart';

import 'size_config.dart';

class TextBtn extends StatelessWidget {
  const TextBtn(
      {Key? key,
      required this.text,
      required this.ontap,
      required this.orientation,
      required this.isPhone})
      : super(key: key);
  final String text;
  final VoidCallback ontap;
  final Orientation orientation;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: ontap,
      child: Text(
        text,
        style: TextStyle(
            letterSpacing: 2,
            fontFamily: "Boogaloo",
            fontSize: isPhone
                ? SizeConfig.blockSizeHorizontal * 7
                : orientation == Orientation.portrait
                    ? SizeConfig.blockSizeVertical * 4
                    : SizeConfig.blockSizeVertical * 5),
      ),
    );
  }
}
