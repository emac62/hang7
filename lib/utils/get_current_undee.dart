import 'package:shared_preferences/shared_preferences.dart';

String setUndees(SharedPreferences prefs) {
  switch (prefs.getString('changeColor')) {
    case "Pink":
      return "assets/images/pinkUndees.png";

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
