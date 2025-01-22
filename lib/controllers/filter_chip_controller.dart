import 'package:flutter/material.dart';
import 'package:test_app/services/storage_service.dart';

class FilterChipController extends ChangeNotifier {
  Set<String> selectedCategories = <String>{};

  Future<void> loadSelectedCategories() async {
    selectedCategories = await StorageService.loadSelectedCategories();
    notifyListeners();
  }

  Future<void> saveSelectedCategories() async {
    await StorageService.saveSelectedCategories(selectedCategories);
  }

  void toggleSelection(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    saveSelectedCategories();
    notifyListeners();
  }
}
