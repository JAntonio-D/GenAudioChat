import 'package:flutter/foundation.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/models/audio_bytes.dart';
import 'package:test_app/models/script.dart';
import 'package:test_app/services/storage_service.dart';

class AudioController with ChangeNotifier {
  List<Audio> audioList = [];
  List<AudioScript> audioScriptList = [];
  List<AudioBytes> audioBytesList = [];

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

  AudioScript? findScript(String title) {
    var index = audioScriptList.indexWhere((script) => script.title == title);
    if (index != -1) {
      return audioScriptList[index];
    }
    return null;
  }

  Future<void> saveAudioBytes() async {
    await StorageService.saveAudioBytesList(audioBytesList);
    notifyListeners();
  }

  Future<void> loadAudioBytes() async {
    audioBytesList = await StorageService.loadAudioBytesList();
    notifyListeners();
  }

  Uint8List? findBytes(String title) {
    var index = audioBytesList.indexWhere((audio) => audio.title == title);
    if (index != -1) {
      return audioBytesList[index].bytes;
    }
    return null;
  }
}
