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
      print("Error al configurar el audio: $e");
    }
  }

  Future<void> playAudio() async {
    if (isLoaded) {
      await audioPlayer.play();
      notifyListeners();
    } else {
      print("El audio no está cargado, por favor configure el audio primero.");
    }
  }

  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      notifyListeners();
    } catch (e) {
      print("Error al pausar el audio: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      notifyListeners();
    } catch (e) {
      print("Error al detener el audio: $e");
    }
  }

  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
