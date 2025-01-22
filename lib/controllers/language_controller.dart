import 'package:flutter/material.dart';
import 'package:test_app/services/storage_service.dart';

class LanguageController extends ChangeNotifier {
  String? selectedLanguage;

  String? selectedLevel;

  Future<void> loadLanguagesPreferences() async {
    final preferences = await StorageService.loadLanguagePreferences();
    selectedLanguage = preferences['language'] ;
    selectedLevel = preferences['level'];
    notifyListeners();
  }

  Future<void> saveSelectedLanguage(String language) async {
    selectedLanguage = language;
    await StorageService.saveSelectedLanguage(language);
    notifyListeners();
  }

  Future<void> saveSelectedLevel(String level) async {
    selectedLevel = level;
    await StorageService.saveSelectedLevel(level);
     notifyListeners();
  }
}
