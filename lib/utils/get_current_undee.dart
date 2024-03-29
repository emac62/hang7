import 'package:flutter/material.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:provider/provider.dart';

String setUndees(BuildContext context) {
  var setProv = Provider.of<SettingsProvider>(context, listen: false);
  switch (setProv.gameUndees) {
    case "Pink":
      return "assets/images/pinkUndees.png";

    case "GreenPlaid":
      return "assets/images/greenPlaid.png";

    case "White":
      return "assets/images/whiteUndees.png";

    case "DarkBlue":
      return "assets/images/blueUndees.png";

    case "DarkBlueTighties":
      return "assets/images/blueTighties.png";

    case "WhiteTighties":
      return "assets/images/whiteTighties.png";

    case "GrayTighties":
      return "assets/images/grayTighties.png";
    case "TealBrief":
      return "assets/images/realBrief.png";
    case "PurpleBrief":
      return "assets/images/purpleBrief.png";
    case "SunsetBrief":
      return "assets/images/sunsetBrief.png";

    default:
      return "assets/images/pinkUndees.png";
  }
}

getMyUndeesImages(List undeeColours) {
  List<Widget> myUndees = [Image.asset("assets/images/pinkUndees.png")];
  List<String> myStrUndees = undeeColours as List<String>;
  for (var i = 0; i < myStrUndees.length; i++) {
    switch (myStrUndees[i]) {
      case "GreenPlaid":
        myUndees.add(Image.asset("assets/images/greenPlaid.png"));
        break;
      case "White":
        myUndees.add(Image.asset("assets/images/whiteUndees.png"));
        break;
      case "DarkBlue":
        myUndees.add(Image.asset("assets/images/blueUndees.png"));
        break;
      case "DarkBlueTighties":
        myUndees.add(Image.asset("assets/images/blueTighties.png"));
        break;
      case "WhiteTighties":
        myUndees.add(Image.asset("assets/images/whiteTighties.png"));
        break;
      case "GrayTighties":
        myUndees.add(Image.asset("assets/images/grayTighties.png"));
        break;
      case "TealBrief":
        myUndees.add(Image.asset("assets/images/tealBrief.png"));
        break;
      case "PurpleBrief":
        myUndees.add(Image.asset("assets/images/purpleBrief.png"));
        break;
      case "SunsetBrief":
        myUndees.add(Image.asset("assets/images/sunsetBrief.png"));
        break;
    }
  }
  return myUndees;
}
