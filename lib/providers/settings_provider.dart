import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late bool _withBGSound;
  late bool _withAnimation;
  late bool _withWordAnimation;
  late String _gameUndees;
  late String _wordPack;
  late List<String> _undeeColours;
  late int _coins;
  late List<String> _myWordPacks;
  late bool _removeAds;
  late bool _reviewed;

  SettingsProvider() {
    _withAnimation = true;
    _withWordAnimation = true;
    _withSound = true;
    _withBGSound = true;
    _gameUndees = "Pink";
    _wordPack = "WordPack 1";
    _undeeColours = ["Pink"];
    _coins = 0;
    _myWordPacks = ["WordPack 1"];
    _removeAds = false;
    _reviewed = false;

    loadPreferences();
  }

  bool get withAnimation => _withAnimation;
  bool get withWordAnimation => _withWordAnimation;
  bool get withSound => _withSound;
  bool get withBGSound => _withBGSound;
  String get gameUndees => _gameUndees;
  String get wordPack => _wordPack;
  List get undeeColours => _undeeColours;
  int get coins => _coins;
  List get myWordPacks => _myWordPacks;
  bool get removeAds => _removeAds;
  bool get reviewed => _reviewed;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("withAnimation", _withAnimation);
    prefs.setBool("withWordAnimation", _withWordAnimation);
    prefs.setBool("withSound", _withSound);
    prefs.setBool("withBGSound", _withBGSound);
    prefs.setString("gameUndees", _gameUndees);
    prefs.setString("wordPack", _wordPack);
    prefs.setStringList('undeeColours', _undeeColours);
    prefs.setInt('coins', _coins);
    prefs.setStringList('myWordPacks', _myWordPacks);
    prefs.setBool('removeAds', _removeAds);
    prefs.setBool('reviewed', _reviewed);
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

  void setWithBGSound(bool withBGSound) {
    _withBGSound = withBGSound;
    notifyListeners();
    savePreferences();
  }

  void setGameUndees(String gameUndees) {
    _gameUndees = gameUndees;
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

  void setCoins(int coins) {
    _coins = coins;

    savePreferences();
  }

  void setMyWordPacks(List myWordPacks) {
    _myWordPacks = myWordPacks as List<String>;
  }

  void setRemoveAds(bool removeAds) {
    _removeAds = removeAds;
    notifyListeners();
    savePreferences();
  }

  void setReviewed(bool reviewed) {
    _reviewed = reviewed;
    notifyListeners();
    savePreferences();
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withAnimation = prefs.getBool('withAnimation');
    bool? withWordAnimation = prefs.getBool('withWordAnimation');
    bool? withSound = prefs.getBool('withSound');
    bool? withBGSound = prefs.getBool('withBGSound');
    String? gameUndees = prefs.getString('gameUndees');
    String? wordPack = prefs.getString('wordPack');
    List<String>? undeeColours = prefs.getStringList('undeeColours');
    int? coins = prefs.getInt('coins');
    List<String>? myWordPacks = prefs.getStringList('myWordPacks');
    bool? removeAds = prefs.getBool('removeAds');
    bool? reviewed = prefs.getBool('reviewed');

    if (withSound != null) setWithSound(withSound);
    if (withBGSound != null) setWithBGSound(withBGSound);
    if (withAnimation != null) setWithAnimation(withAnimation);
    if (withWordAnimation != null) setWithWordAnimation(withWordAnimation);
    if (gameUndees != null) setGameUndees(gameUndees);
    if (wordPack != null) setWordPack(wordPack);
    if (undeeColours != null) setUndeeColours(undeeColours);
    if (coins != null) setCoins(coins);
    if (myWordPacks != null) setMyWordPacks(myWordPacks);
    if (removeAds != null) setRemoveAds(removeAds);
    if (reviewed != null) setReviewed(reviewed);
  }
}
