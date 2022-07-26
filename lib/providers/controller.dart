import 'package:flutter/material.dart';
import 'package:hang7/constants/key_state.dart';
import 'package:hang7/data/calculate_chart_stats.dart';
import 'package:hang7/data/get_stats.dart';
import 'package:hang7/data/key_map.dart';
import 'package:hang7/data/letter_tile_model.dart';
import 'dart:ui' as ui;

class Controller extends ChangeNotifier {
  bool isPhone = true;
  bool isTablet = false;
  bool gameWon = false;
  bool gameCompleted = false;
  String currentWord = "";
  List<String> lettersInWord = [];
  String blankWord = "_______";
  List<LetterTileModel> selectedLetters = [];
  List<String> separatedBlankWord = ["_", "_", "_", "_", "_", "_", "_"];
  int remainingGuesses = 7;
  List containsSelectedLetters = [];
  int correctLetters = 0;
  bool selectedLetterCorrect = false;
  bool selectedLetterIncorrect = false;
  final double devicePixelRatio = ui.window.devicePixelRatio;
  final ui.Size size = ui.window.physicalSize;
  double width = 0;
  double height = 0;

  setCurrentWord({required String word}) => currentWord = word;

  getDevice() {
    width = size.width;
    height = size.height;
    debugPrint("Device width: $width");
    if (devicePixelRatio < 2 && (width > 1200 || height > 1200)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }
    notifyListeners();
  }

  onUserInput({required String letter}) {
    selectedLetterCorrect = false;
    selectedLetterIncorrect = false;
    if (remainingGuesses > 0) {
      selectedLetters
          .add(LetterTileModel(letter: letter, keyState: KeyState.selected));
      keysMap.update(selectedLetters.last.letter, (value) => KeyState.selected);
      notifyListeners();
      lettersInWord = currentWord.split("");

      List result = [];
      if (lettersInWord.contains(letter)) {
        for (var i = 0; i < 7; i++) {
          if (lettersInWord[i] == letter) {
            separatedBlankWord[i] = letter;
            containsSelectedLetters.add(letter);
            blankWord = separatedBlankWord.join("");
            keysMap.update(
                selectedLetters.last.letter, (value) => KeyState.contains);

            notifyListeners();
          }
        }

        correctLetters = containsSelectedLetters.length;
        selectedLetterCorrect = true;
      } else {
        remainingGuesses--;
        selectedLetterIncorrect = true;

        notifyListeners();
        if (remainingGuesses == 0) {
          gameCompleted = true;
          debugPrint("Loser");
        }
      }
      result = lettersInWord
          .where((element) => !containsSelectedLetters.contains(element))
          .toList();
      if (result.isEmpty) {
        gameWon = true;
        gameCompleted = true;
        notifyListeners();
        debugPrint("Winner");
      }
      if (gameCompleted) {
        debugPrint("gameCompleted");
        calculateStats(gameWon: gameWon, remainingGuesses: remainingGuesses);

        setChartStats(undeesLeft: remainingGuesses);
      }

      notifyListeners();
    }
  }

  revealWord() {
    for (var i = 0; i < 7; i++) {
      separatedBlankWord[i] = lettersInWord[i];
    }
  }

  resetGame() {
    currentWord = "";
    gameWon = false;
    gameCompleted = false;
    blankWord = "_______";
    selectedLetters = [];
    separatedBlankWord = ["_", "_", "_", "_", "_", "_", "_"];
    remainingGuesses = 7;
    containsSelectedLetters = [];
    lettersInWord = [];
    correctLetters = 0;
    selectedLetterCorrect = false;
    selectedLetterIncorrect = false;
    notifyListeners();
    debugPrint("resetGame Called");
  }
}
