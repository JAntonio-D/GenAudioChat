import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';

class CategoryFilterChip extends StatelessWidget {

  const CategoryFilterChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      AppLocalizations.of(context)!.category_technology,
      AppLocalizations.of(context)!.category_science,
      AppLocalizations.of(context)!.category_entertainment,
      AppLocalizations.of(context)!.category_health,
      AppLocalizations.of(context)!.category_education,
      AppLocalizations.of(context)!.category_sports,
      AppLocalizations.of(context)!.category_politics,
      AppLocalizations.of(context)!.category_economy,
      AppLocalizations.of(context)!.category_art_culture,
      AppLocalizations.of(context)!.category_travel,
      AppLocalizations.of(context)!.category_food,
      AppLocalizations.of(context)!.category_history,
      AppLocalizations.of(context)!.category_fashion,
      AppLocalizations.of(context)!.category_music,
      AppLocalizations.of(context)!.category_environment,
    ];

    return Consumer<FilterChipController>(builder: (context, controller, _) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: categories.map((String category) {
            final isSelected = controller.selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                controller.toggleSelection(category);
              },
            );
          }).toList(),
        ),
      );
    });
  }
}
