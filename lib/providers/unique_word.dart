import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UniqueWord with ChangeNotifier {
  late List<String> _usedWords1;
  late List<String> _usedWords2;
  late List<String> _usedWords3;
  late List<String> _usedWords4;
  late List<String> _usedWords5;
  late List<String> _usedWords6;
  late List<String> _usedWords7;
  late List<String> _usedWords8;
  late List<String> _usedWords9;
  late List<String> _usedWords10;

  UniqueWord() {
    _usedWords1 = [];
    _usedWords2 = [];
    _usedWords3 = [];
    _usedWords4 = [];
    _usedWords5 = [];
    _usedWords6 = [];
    _usedWords7 = [];
    _usedWords8 = [];
    _usedWords9 = [];
    _usedWords10 = [];

    loadUsedWordsIndexes();
  }

  List get usedWords1 => _usedWords1;
  List get usedWords2 => _usedWords2;
  List get usedWords3 => _usedWords3;
  List get usedWords4 => _usedWords4;
  List get usedWords5 => _usedWords5;
  List get usedWords6 => _usedWords6;
  List get usedWords7 => _usedWords7;
  List get usedWords8 => _usedWords8;
  List get usedWords9 => _usedWords9;
  List get usedWords10 => _usedWords10;

  saveIndexes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("usedWords1", _usedWords1);
    prefs.setStringList("usedWords2", _usedWords2);
    prefs.setStringList("usedWords3", _usedWords3);
    prefs.setStringList("usedWords4", _usedWords4);
    prefs.setStringList("usedWords5", _usedWords5);
    prefs.setStringList("usedWords6", _usedWords6);
    prefs.setStringList("usedWords7", _usedWords7);
    prefs.setStringList("usedWords8", _usedWords8);
    prefs.setStringList("usedWords9", _usedWords9);
    prefs.setStringList("usedWords10", _usedWords10);
  }

  void setUsedWords1(List usedWords1) {
    _usedWords1 = usedWords1 as List<String>;
    saveIndexes();
  }

  void setUsedWords2(List usedWords2) {
    _usedWords2 = usedWords2 as List<String>;

    saveIndexes();
  }

  void setUsedWords3(List usedWords3) {
    _usedWords3 = usedWords3 as List<String>;
    saveIndexes();
  }

  void setUsedWords4(List usedWords4) {
    _usedWords4 = usedWords4 as List<String>;
    saveIndexes();
  }

  void setUsedWords5(List usedWords5) {
    _usedWords5 = usedWords5 as List<String>;
    saveIndexes();
  }

  void setUsedWords6(List usedWords6) {
    _usedWords6 = usedWords6 as List<String>;
    saveIndexes();
  }

  void setUsedWords7(List usedWords7) {
    _usedWords7 = usedWords7 as List<String>;
    saveIndexes();
  }

  void setUsedWords8(List usedWords8) {
    _usedWords8 = usedWords8 as List<String>;
    saveIndexes();
  }

  void setUsedWords9(List usedWords9) {
    _usedWords9 = usedWords9 as List<String>;
    saveIndexes();
  }

  void setUsedWords10(List usedWords10) {
    _usedWords10 = usedWords10 as List<String>;
    saveIndexes();
  }

  void setUsedWordsList(String key, List list) {
    switch (key) {
      case "usedWords1":
        setUsedWords1(list);
        break;
      case "usedWords2":
        setUsedWords2(list);

        break;
      case "usedWords3":
        setUsedWords3(list);
        break;
      case "usedWords4":
        setUsedWords4(list);
        break;
      case "usedWords5":
        setUsedWords5(list);
        break;
      case "usedWords6":
        setUsedWords6(list);
        break;
      case "usedWords7":
        setUsedWords7(list);
        break;
      case "usedWords8":
        setUsedWords8(list);
        break;
      case "usedWords9":
        setUsedWords9(list);
        break;
      case "usedWords10":
        setUsedWords10(list);
        break;
    }
    // notifyListeners();
    saveIndexes();
  }

  loadUsedWordsIndexes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? usedWords1 = prefs.getStringList('usedWords1');
    List<String>? usedWords2 = prefs.getStringList('usedWords2');
    List<String>? usedWords3 = prefs.getStringList('usedWords3');
    List<String>? usedWords4 = prefs.getStringList('usedWords4');
    List<String>? usedWords5 = prefs.getStringList('usedWords5');
    List<String>? usedWords6 = prefs.getStringList('usedWords6');
    List<String>? usedWords7 = prefs.getStringList('usedWords7');
    List<String>? usedWords8 = prefs.getStringList('usedWords8');
    List<String>? usedWords9 = prefs.getStringList('usedWords9');
    List<String>? usedWords10 = prefs.getStringList('usedWords10');

    if (usedWords1 != null) setUsedWords1(usedWords1);
    if (usedWords2 != null) setUsedWords2(usedWords2);
    if (usedWords3 != null) setUsedWords3(usedWords3);
    if (usedWords4 != null) setUsedWords4(usedWords4);
    if (usedWords5 != null) setUsedWords5(usedWords5);
    if (usedWords6 != null) setUsedWords6(usedWords6);
    if (usedWords7 != null) setUsedWords7(usedWords7);
    if (usedWords8 != null) setUsedWords8(usedWords8);
    if (usedWords9 != null) setUsedWords9(usedWords9);
    if (usedWords10 != null) setUsedWords10(usedWords10);
  }
}
