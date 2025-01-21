import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/services/storage_service.dart';

class FilterChipController extends ChangeNotifier {
  Set<String> selectedCategories = <String>{};

  // Cargar datos persistidos
  Future<void> loadSelectedCategories() async {
    selectedCategories = await StorageService.loadSelectedCategories();
    notifyListeners();  // Notifica a los widgets que escuchen el cambio
  }

  // Guardar los datos seleccionados
  Future<void> saveSelectedOptions() async {
    await StorageService.saveSelectedCategories(selectedCategories);
  }

  // Actualizar la selección
  void toggleSelection(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    saveSelectedOptions();  // Persistir la selección
    notifyListeners();  // Notificar a la UI
  }
}
