import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late bool _withAnimation;
  late String _changeColor;

  SettingsProvider() {
    _withAnimation = true;
    _withSound = true;
    _changeColor = "Pink";

    loadPreferences();
  }

  bool get withAnimation => _withAnimation;
  bool get withSound => _withSound;
  String get changeColor => _changeColor;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("withAnimation", _withAnimation);
    prefs.setBool("withSound", _withSound);
    prefs.setString("changeColor", _changeColor);
  }

  void setWithAnimation(bool withAnimation) {
    _withAnimation = withAnimation;
    notifyListeners();
    savePreferences();
  }

  void setWithSound(bool withSound) {
    _withSound = withSound;
    notifyListeners();
    savePreferences();
  }

  void setChangeColor(String changeColor) {
    _changeColor = changeColor;
    notifyListeners();
    savePreferences();
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withAnimation = prefs.getBool('withAnimation');
    bool? withSound = prefs.getBool('withSound');
    String? changeColor = prefs.getString('changeColor');

    if (withSound != null) setWithSound(withSound);
    if (withAnimation != null) setWithAnimation(withAnimation);
    if (changeColor != null) setChangeColor(changeColor);
  }
}
