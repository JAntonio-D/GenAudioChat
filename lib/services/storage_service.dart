import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/models/audio_bytes.dart';
import 'package:test_app/models/languagePreferences.dart';
import 'package:test_app/models/script.dart';

class StorageService {
  static Future<void> saveSelectedCategories(
      Set<String> selectedCategories) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCategories', selectedCategories.toList());
  }

  static Future<Set<String>> loadSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedCategories =
        prefs.getStringList('selectedCategories') ?? [];
    return savedCategories.toSet();
  }

  static Future<void> saveSelectedLanguage(String selectedLanguage) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', selectedLanguage);
  }

  static Future<LanguagePreferences> loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedLanguage = prefs.getString('selectedLanguage') ?? '';
    final String savedLevel = prefs.getString('selectedLevel') ?? '';
    return LanguagePreferences(language: savedLanguage, level: savedLevel);
  }

  static Future<void> saveSelectedLevel(String selectedLevel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLevel', selectedLevel);
  }

  static Future<void> saveAudioList(List<Audio> audioList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> audioListJson =
        audioList.map((audio) => audio.toJson()).toList();
    await prefs.setStringList('audio_list', audioListJson);
  }

  static Future<List<Audio>> loadAudioList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? audioListJson = prefs.getStringList('audio_list');

    if (audioListJson == null) {
      return [];
    }

    return audioListJson.map((json) => Audio.fromPlainJson(json)).toList();
  }

  static Future<void> saveAudioScriptList(List<AudioScript> scriptList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scriptListJson =
        scriptList.map((script) => script.toJsonString()).toList();
    await prefs.setStringList('script_list', scriptListJson);
  }

  static Future<List<AudioScript>> loadAudioScriptList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? scriptListJson = prefs.getStringList('script_list');

    if (scriptListJson == null) return [];

    return scriptListJson.map((json) => AudioScript.fromJson(json)).toList();
  }

  static Future<void> saveAudioBytesList(
      List<AudioBytes> audioBytesList) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> audioBytesListString = audioBytesList.map((audioBytes) {
      Map<String, dynamic> map = audioBytes.toMap();
      String jsonString = jsonEncode(map);
      return jsonString;
    }).toList();

    await prefs.setStringList('audioBytesList', audioBytesListString);
  }

  static Future<List<AudioBytes>> loadAudioBytesList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? audioBytesListString = prefs.getStringList('audioBytesList');

    if (audioBytesListString == null) return [];

    List<AudioBytes> audioBytesList = audioBytesListString.map((jsonString) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      return AudioBytes.fromMap(map);
    }).toList();

    return audioBytesList;
  }
}
