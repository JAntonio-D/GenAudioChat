import 'package:flutter/foundation.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/services/storage_service.dart';

class AudioController with ChangeNotifier {
  List<Audio> audioList = [];

  Future<void> loadAudioList() async {
    audioList = await StorageService.loadAudioList();
    notifyListeners();
  }

  Future<void> saveAudioList() async {
    await StorageService.saveAudioList(audioList);
    notifyListeners();
  }

  void addAudio(String title, String description) {
    final newAudio = Audio(title: title, description: description);
    audioList.add(newAudio);
    saveAudioList();
  }

  void removeAudio(Audio audio) {
    audioList.remove(audio);
    saveAudioList();
  }
}
