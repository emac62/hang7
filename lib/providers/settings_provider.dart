import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late bool _withAnimation;
  late String _changeColor;
  late String _wordGroup;
  late List<String> _undeeColours;

  SettingsProvider() {
    _withAnimation = true;
    _withSound = true;
    _changeColor = "Pink";
    _wordGroup = "Random 1";
    _undeeColours = ["Pink"];

    loadPreferences();
  }

  bool get withAnimation => _withAnimation;
  bool get withSound => _withSound;
  String get changeColor => _changeColor;
  String get wordGroup => _wordGroup;
  List get undeeColours => _undeeColours;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("withAnimation", _withAnimation);
    prefs.setBool("withSound", _withSound);
    prefs.setString("changeColor", _changeColor);
    prefs.setString("wordGroup", _wordGroup);
    prefs.setStringList('undeeColours', _undeeColours);
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

  void setWordGroup(String wordGroup) {
    _wordGroup = wordGroup;
    notifyListeners();
    savePreferences();
  }

  void setUndeeColours(List undeeColours) {
    _undeeColours = undeeColours as List<String>;
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withAnimation = prefs.getBool('withAnimation');
    bool? withSound = prefs.getBool('withSound');
    String? changeColor = prefs.getString('changeColor');
    String? wordGroup = prefs.getString('wordGroup');
    List<String>? undeeColours = prefs.getStringList('undeeColours');

    if (withSound != null) setWithSound(withSound);
    if (withAnimation != null) setWithAnimation(withAnimation);
    if (changeColor != null) setChangeColor(changeColor);
    if (wordGroup != null) setWordGroup(wordGroup);
    if (undeeColours != null) setUndeeColours(undeeColours);
  }
}
