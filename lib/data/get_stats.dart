import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

calculateStats({required bool gameWon, required int remainingGuesses}) async {
  int gamesPlayed = 0;
  int gamesWon = 0;
  int winPercentage = 0;
  int currentStreak = 0;
  int maxStreak = 0;
  int totalUndeesLeft = 0;
  int avgUndeesLeft = 0;
  int coins = 0;
  var prefs = await SharedPreferences.getInstance();
  var savedStats = await getGameStats();
  if (savedStats != null) {
    gamesPlayed = int.parse(savedStats[0]);
    gamesWon = int.parse(savedStats[1]);
    winPercentage = int.parse(savedStats[2]);
    currentStreak = int.parse(savedStats[3]);
    maxStreak = int.parse(savedStats[4]);
    totalUndeesLeft = int.parse(savedStats[5]);
    avgUndeesLeft = int.parse(savedStats[6]);
  }
  coins = prefs.getInt('coins') ?? 0;

  gamesPlayed += 1;

  if (gamesPlayed == 25 ||
      gamesPlayed == 50 ||
      gamesPlayed == 75 ||
      gamesPlayed == 100) {
    coins = coins + 10;
  }

  if (gameWon) {
    coins = coins + 10 + remainingGuesses;
    gamesWon++;
    currentStreak++;
  } else {
    currentStreak = 0;
  }
  if (currentStreak > maxStreak) {
    maxStreak = currentStreak;
  }

  winPercentage = ((gamesWon / gamesPlayed) * 100).toInt();
  totalUndeesLeft = totalUndeesLeft + remainingGuesses;
  avgUndeesLeft = totalUndeesLeft ~/ gamesPlayed;

  prefs.setInt('coins', coins);
  prefs.setStringList('gameStats', <String>[
    gamesPlayed.toString(),
    gamesWon.toString(),
    winPercentage.toString(),
    currentStreak.toString(),
    maxStreak.toString(),
    totalUndeesLeft.toString(),
    avgUndeesLeft.toString(),
  ]);

  debugPrint("calculateStats: gameStats ${prefs.getStringList('gameStats')}");
}

Future<List<String>?> getGameStats() async {
  var prefs = await SharedPreferences.getInstance();
  var gameStats = prefs.getStringList('gameStats');
  if (gameStats != null) {
    return gameStats;
  } else {
    return null;
  }
}
