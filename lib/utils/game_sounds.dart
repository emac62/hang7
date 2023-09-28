import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GameSounds {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void playErrorSound() async {
    List errorSounds = [
      "failure1.mp3",
      "inhale.mp3",
      "aww.mp3",
      "drum.mp3",
    ];
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    int randomIndex = Random().nextInt(errorSounds.length);
    await _audioPlayer.setSource(AssetSource(errorSounds[randomIndex]));
    try {
      if (!isPlaying) {
        await _audioPlayer.play(AssetSource(errorSounds[randomIndex]));
      }
    } catch (e) {
      debugPrint("Error playing error sound: $e");
    }
  }

  void stopGameSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    if (isPlaying) {
      _audioPlayer.stop();
      isPlaying = false;
    }
  }

  void playSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("whoosh.mp3"));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing start sound: $e");
    }
  }

  void playSuccessSound() {
    final AudioPlayer playSuccess = AudioPlayer();
    bool isPlaying = playSuccess.state == PlayerState.playing;

    try {
      if (!isPlaying) {
        playSuccess.play(AssetSource('success.mp3'));
        bool result = playSuccess.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing success sound: $e");
    }
  }

  void playWinningSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;

    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("fanfare.mp3"));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing winning sound: $e");
    }
  }

  void playWedgieSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;

    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("fail.mp3"));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing wedgie sound: $e");
    }
  }

  void playFireworksSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;

    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource('fireworks.mp3'));
        bool result = _audioPlayer.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
      }
    } catch (e) {
      debugPrint("Error playing wedgie sound: $e");
    }
  }

  void disposeGameSound() {
    _audioPlayer.dispose();
  }
}
