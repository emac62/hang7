import 'package:flutter/material.dart';
import 'package:hang7/utils/game_sounds.dart';

import 'package:provider/provider.dart';

import '../animations/route.dart';
import '../constants/key_state.dart';
import '../data/key_map.dart';
import '../pages/game_board.dart';
import '../pages/options.dart';
import '../providers/controller.dart';
import '../providers/settings_provider.dart';
import '../providers/unique_word.dart';

showOutOfWords(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Words!'),
          content: const Text(
              'You have used all the words in this word pack. Go to Options to change your pack or buy more coins if needed.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Get More Words!'),
              onPressed: () {
                Navigator.pushReplacement(
                    context, FadeRoute(page: const Options()));
              },
            ),
          ],
        );
      });
}

newGame(BuildContext context) {
  keysMap.updateAll((key, value) => value = KeyState.unselected);
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  Provider.of<Controller>(context, listen: false).resetGame();
  var gameSounds = GameSounds();
  settings.withSound ? gameSounds.playSound() : null;
  Navigator.pushReplacement(context, FadeRoute(page: const GameBoard()));
}

int currentWPRemainingWords = 50;
getCurrentRemainingWords(BuildContext context) {
  var settProv = Provider.of<SettingsProvider>(context, listen: false);
  var unqProv = Provider.of<UniqueWord>(context, listen: false);
  String wp = settProv.wordPack;
  int numberOfUsedWordsInPack = 0;

  switch (wp) {
    case "WordPack 1":
      List<String> l = unqProv.usedWords1 as List<String>;
      numberOfUsedWordsInPack = l.length;

      break;
    case "WordPack 2":
      List<String> l = unqProv.usedWords2 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 3":
      List<String> l = unqProv.usedWords3 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 4":
      List<String> l = unqProv.usedWords4 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 5":
      List<String> l = unqProv.usedWords5 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 6":
      List<String> l = unqProv.usedWords6 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 7":
      List<String> l = unqProv.usedWords7 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 8":
      List<String> l = unqProv.usedWords8 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 9":
      List<String> l = unqProv.usedWords9 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
    case "WordPack 10":
      List<String> l = unqProv.usedWords10 as List<String>;
      numberOfUsedWordsInPack = l.length;
      break;
  }
  currentWPRemainingWords = 50 - numberOfUsedWordsInPack;
}

checkRemainingWords(BuildContext context) {
  getCurrentRemainingWords(context);
  currentWPRemainingWords == 0 ? showOutOfWords(context) : newGame(context);
}
