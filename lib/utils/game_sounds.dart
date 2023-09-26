import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GameSounds {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void playErrorSound() {
    List errorSounds = [
      "failure1.mp3",
      "hhh.mov",
      "aww.mov",
      "drum.mp3",
    ];
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    int randomIndex = Random().nextInt(3);
    _audioPlayer.setSource(AssetSource(errorSounds[randomIndex]));
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource(errorSounds[randomIndex]));
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

  void playSuccessSound() {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    _audioPlayer.setSource(AssetSource("success.mov"));
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("success.mov"));
        bool result = _audioPlayer.state == PlayerState.playing;
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
    _audioPlayer.setSource(AssetSource("fanfare.mp3"));
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
    _audioPlayer.setSource(AssetSource("fail.mp3"));
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
    _audioPlayer.setSource(AssetSource("fireworks.mp3"));
    try {
      if (!isPlaying) {
        _audioPlayer.play(AssetSource("fireworks.mp3"));
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
