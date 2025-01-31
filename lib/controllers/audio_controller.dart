import 'package:flutter/foundation.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/models/script.dart';
import 'package:test_app/services/storage_service.dart';

class AudioController with ChangeNotifier {
  List<Audio> audioList = [];
  List<AudioScript> audioScriptList = [];

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

  Future<void> loadAudioScriptList() async {
    audioScriptList = await StorageService.loadAudioScriptList();
    notifyListeners();
  }

  Future<void> saveAudioScriptList() async {
    await StorageService.saveAudioScriptList(audioScriptList);
    notifyListeners();
  }

  AudioScript findScript(String title, String description) {
    return audioScriptList.firstWhere(
      (script) => script.title == title
     );
  }


}
