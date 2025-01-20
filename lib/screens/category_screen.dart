import 'package:flutter/material.dart';
import 'package:test_app/screens/language_screen.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/widgets/category_filter_chip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Set<CategoryFilter> filters = <CategoryFilter>{};

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Selecciona una categoría de tu interés'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.selectCategory,
                style: textTheme.titleLarge),
            const SizedBox(height: 5.0),
            CategoryFilterChip(
              filters: filters,
              onFilterChanged: (Set<CategoryFilter> selectedFilters) {
                setState(() {
                  filters = selectedFilters;
                });
              },
            ),
            const SizedBox(height: 10.0),
            Text(
              'Tus temas: ${filters.map((CategoryFilter e) => e.name).join(', ')}',
              style: textTheme.labelLarge,
            ),
            Button(
                buttonText: "Next",
                isEnabled: filters.isNotEmpty,
                onPressed: () {
                  // Navegar a la segunda pantalla
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageSelectionScreen()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
