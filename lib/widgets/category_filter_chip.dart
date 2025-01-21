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
  _CategoryFilterChipState createState() => _CategoryFilterChipState();
}

class _CategoryFilterChipState extends State<CategoryFilterChip> {
  Timer? _debounceTimer;
  List<String> allCategories = [];
  Set<String> lastFetchedCategories = {};
  int apiCallCount = 0;
  static const int maxApiCalls = 3;

  void _onCategoryToggle(String category, FilterChipController controller) {
    controller.toggleSelection(category);

    _startDebounce(controller.selectedCategories);
  }

  void _startDebounce(Set<String> selectedCategories) {
    if (selectedCategories.isEmpty) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      if (_shouldFetchCategories(selectedCategories)) {
        context.read<LoaderController>().showLoader();
        _fetchRelatedCategories(selectedCategories);
      }
    });
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
      String categories = selectedCategories.length > 1
          ? selectedCategories.join(', ')
          : selectedCategories.first;
      print('Selected Categories: ${categories}');
      final response = [
        "games",
        "RPG",
        "Fantasy",
        "Smartphone",
        "PS5",
        "Nintendo Switch"
      ]; // await ControlledGeneration().getCategories(categories);
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        allCategories = {
          ...allCategories,
          ...response,
        }.toList();
      });

      lastFetchedCategories = selectedCategories.toSet();
      apiCallCount++;
      debugPrint('API call count: $apiCallCount');
    } catch (e) {
      debugPrint('Error fetching related categories: $e');
    }
    context.read<LoaderController>().hideLoader();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
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

    final  List<String> initialCategories = [
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
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: allCategories.map((String category) {
            final isSelected = controller.selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => _onCategoryToggle(category, controller),
            );
          }).toList(),
        ),
      );
    });
  }
}
