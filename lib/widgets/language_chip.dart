import 'package:flutter/material.dart';

class LanguageChoiceChip extends StatelessWidget {
  final String languageName;
  final String imageAsset;
  final bool isSelected;
  final ValueChanged<String> onSelected;
  
  const LanguageChoiceChip({
    super.key,
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
          Image.asset(imageAsset, width: 20),
          SizedBox(width: 8),
          Text(languageName),
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        onSelected(selected ? languageName : '');
      },
    );
  }
}
