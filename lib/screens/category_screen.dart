import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
        body: FutureBuilder(
      future: context.read<FilterChipController>().loadSelectedCategories(),
      builder: (context, snapshot) {
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.selectCategory,
                  style: textTheme.titleLarge),
              const SizedBox(height: 5.0),
              CategoryFilterChip(),
              const SizedBox(height: 10.0),
              Consumer<FilterChipController>(
                // Remove this
                builder: (context, controller, _) {
                  return Text(
                    'Tus temas: ${controller.selectedCategories.join(', ')}',
                    style: textTheme.labelLarge,
                  );
                },
              ),
              Consumer<FilterChipController>(
                builder: (context, controller, _) {
                  return Button(
                      buttonText: "Next", // Change this to AppLocalizations
                      isEnabled: controller.selectedCategories.isNotEmpty,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageSelectionScreen()),
                        );
                      });
                },
              ),
            ],
          ),
        );
      },
    ));
  }
}
