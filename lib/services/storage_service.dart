import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/models/languagePreferences.dart';

class StorageService {
  static Future<void> saveSelectedCategories(Set<String> selectedCategories) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCategories', selectedCategories.toList());
  }

  static Future<Set<String>> loadSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedCategories = prefs.getStringList('selectedCategories') ?? [];
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
    List<String> audioListJson = audioList.map((audio) => audio.toJson()).toList();
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

}
