import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late bool _withAnimation;
  late bool _withWordAnimation;
  late String _changeColor;
  late String _wordPack;
  late List<String> _undeeColours;

  SettingsProvider() {
    _withAnimation = true;
    _withWordAnimation = true;
    _withSound = true;
    _changeColor = "Pink";
    _wordPack = "WordPack 1";
    _undeeColours = ["Pink"];

    loadPreferences();
  }

  bool get withAnimation => _withAnimation;
  bool get withWordAnimation => _withWordAnimation;
  bool get withSound => _withSound;
  String get changeColor => _changeColor;
  String get wordPack => _wordPack;
  List get undeeColours => _undeeColours;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("withAnimation", _withAnimation);
    prefs.setBool("withWordAnimation", _withWordAnimation);
    prefs.setBool("withSound", _withSound);
    prefs.setString("changeColor", _changeColor);
    prefs.setString("wordPack", _wordPack);
    prefs.setStringList('undeeColours', _undeeColours);
  }

  void setWithAnimation(bool withAnimation) {
    _withAnimation = withAnimation;
    notifyListeners();
    savePreferences();
  }

  void setWithWordAnimation(bool withWordAnimation) {
    _withWordAnimation = withWordAnimation;
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

  void setWordPack(String wordPack) {
    _wordPack = wordPack;
    notifyListeners();
    savePreferences();
  }

  void setUndeeColours(List undeeColours) {
    _undeeColours = undeeColours as List<String>;
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withAnimation = prefs.getBool('withAnimation');
    bool? withWordAnimation = prefs.getBool('withWordAnimation');
    bool? withSound = prefs.getBool('withSound');
    String? changeColor = prefs.getString('changeColor');
    String? wordPack = prefs.getString('wordPack');
    List<String>? undeeColours = prefs.getStringList('undeeColours');

    if (withSound != null) setWithSound(withSound);
    if (withAnimation != null) setWithAnimation(withAnimation);
    if (withWordAnimation != null) setWithWordAnimation(withWordAnimation);
    if (changeColor != null) setChangeColor(changeColor);
    if (wordPack != null) setWordPack(wordPack);
    if (undeeColours != null) setUndeeColours(undeeColours);
  }
}
