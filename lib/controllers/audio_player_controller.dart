import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/audio_service.dart';
import 'package:test_app/utils/audio_utils.dart';

class AudioPlayerController extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isAudioSet = false;

  bool get isPlaying => audioPlayer.playing;
  bool get isLoaded => audioPlayer.audioSource != null;
  get playerState => audioPlayer.playerState.processingState;

  Future<void> setAudio(Uint8List combinedAudio) async {
    if (_isAudioSet) return;

    try {
      await audioPlayer.setAudioSource(MySource(combinedAudio));
      _isAudioSet = true;
      notifyListeners();
    } catch (e) {
      debugPrint("set audio error: $e");
    }
  }

  Future<void> playAudio() async {
    if (isLoaded) {
      await audioPlayer.play();
      notifyListeners();
    }
  }

  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      notifyListeners();
    } catch (e) {
      debugPrint("Pause audio error: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      notifyListeners();
    } catch (e) {
      debugPrint("Stop audio error: $e");
    }
  }

  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
