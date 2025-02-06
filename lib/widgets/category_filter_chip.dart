import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/services/controlled_generation.dart';

class CategoryFilterChip extends StatefulWidget {
  const CategoryFilterChip({Key? key}) : super(key: key);

  @override
  CategoryFilterChipState createState() => CategoryFilterChipState();
}

class CategoryFilterChipState extends State<CategoryFilterChip> {
  List<String> allCategories = [];
  Set<String> lastFetchedCategories = {};
  int apiCallCount = 0;
  static const int maxApiCalls = 7;

  void _onCategoryToggle(String category, FilterChipController controller) {
    controller.toggleSelection(category);
  }

  void safeFetchCategories(Set<String> selectedCategories) {
    if (selectedCategories.isEmpty) return;

    if (_shouldFetchCategories(selectedCategories)) {
      context.read<LoaderController>().showLoader();
      _fetchRelatedCategories(selectedCategories);
    }
  }

  bool _shouldFetchCategories(Set<String> selectedCategories) {
    if (selectedCategories.isEmpty) return false;
    if (apiCallCount >= maxApiCalls) {
      debugPrint('Maximum API call limit reached. Skipping API call.');
      return false;
    }
    if (lastFetchedCategories.containsAll(selectedCategories)) {
      debugPrint(
          'Selected categories are a subset of last fetched. Skipping API call.');
      return false;
    }
    return true;
  }

  Future<void> _fetchRelatedCategories(Set<String> selectedCategories) async {
    try {
      Set<String> processedCategories = lastFetchedCategories.toSet();
      List<String> newSelectedCategories = selectedCategories
          .where((item) => !processedCategories.contains(item))
          .toList();

      String categories = newSelectedCategories.length > 1
          ? newSelectedCategories.join(', ')
          : newSelectedCategories.first;
      final currentLocale = AppLocalizations.of(context)?.localeName ?? '';

      final response = await ControlledGeneration()
          .getCategories(categories, currentLocale, allCategories.toString());
      setState(() {
        allCategories = {
          ...allCategories,
          ...response,
        }.toList();
      });

      lastFetchedCategories = selectedCategories.toSet();
      apiCallCount++;
    } catch (e) {
      debugPrint('Error fetching related categories: $e');
    }
    context.read<LoaderController>().hideLoader();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCategories();
    });
  }

  Future<void> _initializeCategories() async {
    final localizations = AppLocalizations.of(context);
    final controller = context.read<FilterChipController>();

    final List<String> initialCategories = [
      localizations!.category_technology,
      localizations.category_science,
      localizations.category_entertainment,
      localizations.category_health,
      localizations.category_education,
      localizations.category_sports,
      localizations.category_politics,
      localizations.category_economy,
      localizations.category_art_culture,
      localizations.category_travel,
      localizations.category_food,
      localizations.category_history,
      localizations.category_fashion,
      localizations.category_music,
      localizations.category_environment,
    ];

    await controller.loadSelectedCategories();
    setState(() {
      allCategories = {
        ...initialCategories,
        ...controller.selectedCategories,
      }.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterChipController>(builder: (context, controller, _) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxHeight: 500),
          child: Scrollbar(
              thumbVisibility: true,
              thickness: 4.0,
              radius: Radius.circular(10),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: allCategories.map((String category) {
                    final isSelected =
                        controller.selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) =>
                          _onCategoryToggle(category, controller),
                    );
                  }).toList(),
                ),
              )),
        ),
      );
    });
  }
}
