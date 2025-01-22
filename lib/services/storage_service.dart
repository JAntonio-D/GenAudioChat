import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<Map<String, String>> loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String savedLanguage = prefs.getString('selectedLanguage') ?? '';
    final String savedLevel = prefs.getString('selectedLevel') ?? '';
    return {'language': savedLanguage, 'level': savedLevel};
  }

    static Future<void> saveSelectedLevel(String selectedLevel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLevel', selectedLevel);
  }

}
