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
}
