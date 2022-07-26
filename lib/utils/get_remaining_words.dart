import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

getMyWordPackRemainingWords(SharedPreferences prefs) {
  List<String> myRemaningWords = [];
  List<String> myWordPacks =
      prefs.getStringList('myWordPacks') ?? ["WordPack 1"];
  debugPrint("getMyWordPackRemainingWords: ${myWordPacks.toString()}");
  for (var i = 0; i < myWordPacks.length; i++) {
    List<String> l = [];
    switch (myWordPacks[i]) {
      case "WordPack 1":
        l = prefs.getStringList('usedWords1') ?? [];
        break;
      case "WordPack 2":
        l = prefs.getStringList('usedWords2') ?? [];
        break;
      case "WordPack 3":
        l = prefs.getStringList('usedWords3') ?? [];
        break;
      case "WordPack 4":
        l = prefs.getStringList('usedWords4') ?? [];
        break;
      case "WordPack 5":
        l = prefs.getStringList('usedWords5') ?? [];
        break;
      case "WordPack 6":
        l = prefs.getStringList('usedWords6') ?? [];
        break;
      case "WordPack 7":
        l = prefs.getStringList('usedWords7') ?? [];
        break;
      case "WordPack 8":
        l = prefs.getStringList('usedWords8') ?? [];
        break;
      case "WordPack 9":
        l = prefs.getStringList('usedWords9') ?? [];
        break;
      case "WordPack 10":
        l = prefs.getStringList('usedWords10') ?? [];
        break;
    }
    final int r = 50 - l.length;
    myRemaningWords.add(r.toString());
  }
  debugPrint("myRemainingWords: ${myRemaningWords.toString()}");
  return myRemaningWords;
}

resetMyWordPackRemainingWords(SharedPreferences prefs, String name) {
  List<String> myRemaningWords = [];

  switch (name) {
    case "WordPack 1":
      prefs.setStringList('usedWords1', myRemaningWords);
      break;
    case "WordPack 2":
      prefs.setStringList('usedWords2', myRemaningWords);
      break;
    case "WordPack 3":
      prefs.setStringList('usedWords3', myRemaningWords);
      break;
    case "WordPack 4":
      prefs.setStringList('usedWords4', myRemaningWords);
      break;
    case "WordPack 5":
      prefs.setStringList('usedWords5', myRemaningWords);
      break;
    case "WordPack 6":
      prefs.setStringList('usedWords6', myRemaningWords);
      break;
    case "WordPack 7":
      prefs.setStringList('usedWords7', myRemaningWords);
      break;
    case "WordPack 8":
      prefs.setStringList('usedWords8', myRemaningWords);
      break;
    case "WordPack 9":
      prefs.setStringList('usedWords9', myRemaningWords);
      break;
    case "WordPack 10":
      prefs.setStringList('usedWords10', myRemaningWords);
      break;
  }
}
