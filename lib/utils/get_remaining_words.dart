import 'package:flutter/material.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/providers/unique_word.dart';
import 'package:provider/provider.dart';

getMyWordPackRemainingWords(context) {
  var uniqueWords = Provider.of<UniqueWord>(context, listen: false);
  var settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  List<String> myRemaningWords = [];
  List<String> myWordPacks = settingsProvider.myWordPacks as List<String>;

  for (var i = 0; i < myWordPacks.length; i++) {
    List<String>? l = [];

    switch (myWordPacks[i]) {
      case "WordPack 1":
        l = uniqueWords.usedWords1 as List<String>;

        break;
      case "WordPack 2":
        l = uniqueWords.usedWords2 as List<String>;
        break;
      case "WordPack 3":
        l = uniqueWords.usedWords3 as List<String>;
        break;
      case "WordPack 4":
        l = uniqueWords.usedWords4 as List<String>;
        break;
      case "WordPack 5":
        l = uniqueWords.usedWords5 as List<String>;
        break;
      case "WordPack 6":
        l = uniqueWords.usedWords6 as List<String>;
        break;
      case "WordPack 7":
        l = uniqueWords.usedWords7 as List<String>;
        break;
      case "WordPack 8":
        l = uniqueWords.usedWords8 as List<String>;
        break;
      case "WordPack 9":
        l = uniqueWords.usedWords9 as List<String>;
        break;
      case "WordPack 10":
        l = uniqueWords.usedWords10 as List<String>;
        break;
    }
    final int r = 50 - l.length;
    myRemaningWords.add(r.toString());
  }

  return myRemaningWords;
}

resetMyWordPackRemainingWords(BuildContext context, String name) {
  var settingsProvider = Provider.of<UniqueWord>(context, listen: false);
  List<String> myRemaningWords = [];
  switch (name) {
    case "WordPack 1":
      settingsProvider.setUsedWords1(myRemaningWords);
      break;
    case "WordPack 2":
      settingsProvider.setUsedWords2(myRemaningWords);
      break;
    case "WordPack 3":
      settingsProvider.setUsedWords3(myRemaningWords);
      break;
    case "WordPack 4":
      settingsProvider.setUsedWords4(myRemaningWords);
      break;
    case "WordPack 5":
      settingsProvider.setUsedWords5(myRemaningWords);
      break;
    case "WordPack 6":
      settingsProvider.setUsedWords6(myRemaningWords);
      break;
    case "WordPack 7":
      settingsProvider.setUsedWords7(myRemaningWords);
      break;
    case "WordPack 8":
      settingsProvider.setUsedWords8(myRemaningWords);
      break;
    case "WordPack 9":
      settingsProvider.setUsedWords9(myRemaningWords);
      break;
    case "WordPack 10":
      settingsProvider.setUsedWords10(myRemaningWords);
      break;
  }
}
