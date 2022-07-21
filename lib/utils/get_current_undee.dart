import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String setUndees(SharedPreferences prefs) {
  switch (prefs.getString('changeColor')) {
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

    default:
      return "assets/images/pinkUndees.png";
  }
}

getMyUndeesImages(SharedPreferences prefs) {
  List<Widget> myUndees = [Image.asset("assets/images/pinkUndees.png")];
  List<String> myStrUndees = prefs.getStringList('undeeColours') ?? ["Pink"];
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
    }
  }
  return myUndees;
}
