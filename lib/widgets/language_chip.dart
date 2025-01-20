import 'package:flutter/material.dart';

class LanguageChoiceChip extends StatelessWidget {
  final String languageCode; // Código del idioma (ej. 'es', 'en', 'fr')
  final String languageName; // Nombre del idioma (ej. 'Español', 'Inglés')
  final String imageAsset; // Ruta del asset de la bandera
  final bool isSelected; // Indica si el chip está seleccionado
  final ValueChanged<String> onSelected; // Función de callback cuando se selecciona un chip

  // Constructor
  const LanguageChoiceChip({
    super.key,
    required this.languageCode,
    required this.languageName,
    required this.imageAsset,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imageAsset, width: 20), // Muestra la bandera
          SizedBox(width: 8),
          Text(languageName), // Muestra el nombre del idioma
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        // Llama a la función de callback con el código del idioma
        onSelected(selected ? languageCode : '');
      },
    );
  }
}
