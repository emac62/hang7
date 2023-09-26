import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class BackgroundMusic {
  final AudioPlayer _audioPlayerBG = AudioPlayer();
  bool isPlaying = false;

  void playBackgroundMusic() {
    _audioPlayerBG.setSource(AssetSource("outside.mp3"));
    try {
      if (!isPlaying) {
        _audioPlayerBG.play(AssetSource('outside.mp3'));
        _audioPlayerBG.setVolume(0.75);
        bool result = _audioPlayerBG.state == PlayerState.playing;
        if (result) {
          isPlaying = true;
        }
        _audioPlayerBG.onPlayerComplete.listen((event) {
          _audioPlayerBG.play(AssetSource('outside.mp3'));
        });
      }
    } catch (e) {
      debugPrint("Error playing background music: $e");
    }
  }

  void pauseBackgroundMusic() {
    if (_audioPlayerBG.state == PlayerState.playing) {
      _audioPlayerBG.pause();
      isPlaying = false;
    }
  }

  void stopBackgroundMusic() {
    if (_audioPlayerBG.state == PlayerState.playing) {
      _audioPlayerBG.stop();
      isPlaying = false;
    }
  }

  void disposeBackgroundMusic() {
    _audioPlayerBG.dispose();
  }
}
