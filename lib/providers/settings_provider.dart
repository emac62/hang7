import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late bool _withSound;
  late bool _withAnimation;
  late bool _withWordAnimation;
  late String _gameUndees;
  late String _wordPack;
  late List<String> _undeeColours;
  late int _coins;
  late List<String> _myWordPacks;

  SettingsProvider() {
    _withAnimation = true;
    _withWordAnimation = true;
    _withSound = true;
    _gameUndees = "Pink";
    _wordPack = "WordPack 1";
    _undeeColours = ["Pink"];
    _coins = 0;
    _myWordPacks = ["WordPack 1"];
    loadPreferences();
  }

  bool get withAnimation => _withAnimation;
  bool get withWordAnimation => _withWordAnimation;
  bool get withSound => _withSound;
  String get gameUndees => _gameUndees;
  String get wordPack => _wordPack;
  List get undeeColours => _undeeColours;
  int get coins => _coins;
  List get myWordPacks => _myWordPacks;

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("withAnimation", _withAnimation);
    prefs.setBool("withWordAnimation", _withWordAnimation);
    prefs.setBool("withSound", _withSound);
    prefs.setString("gameUndees", _gameUndees);
    prefs.setString("wordPack", _wordPack);
    prefs.setStringList('undeeColours', _undeeColours);
    prefs.setInt('coins', _coins);
    prefs.setStringList('myWordPacks', _myWordPacks);
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
    notifyListeners();
    savePreferences();
  }

  void setMyWordPacks(List myWordPacks) {
    _myWordPacks = myWordPacks as List<String>;
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? withAnimation = prefs.getBool('withAnimation');
    bool? withWordAnimation = prefs.getBool('withWordAnimation');
    bool? withSound = prefs.getBool('withSound');
    String? gameUndees = prefs.getString('gameUndees');
    String? wordPack = prefs.getString('wordPack');
    List<String>? undeeColours = prefs.getStringList('undeeColours');
    int? coins = prefs.getInt('coins');
    List<String>? myWordPacks = prefs.getStringList('myWordPacks');

    if (withSound != null) setWithSound(withSound);
    if (withAnimation != null) setWithAnimation(withAnimation);
    if (withWordAnimation != null) setWithWordAnimation(withWordAnimation);
    if (gameUndees != null) setGameUndees(gameUndees);
    if (wordPack != null) setWordPack(wordPack);
    if (undeeColours != null) setUndeeColours(undeeColours);
    if (coins != null) setCoins(coins);
    if (myWordPacks != null) setMyWordPacks(myWordPacks);
  }
}
