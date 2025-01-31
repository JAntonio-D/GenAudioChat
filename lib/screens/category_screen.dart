import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/screens/audio_list_screen.dart';
import 'package:test_app/screens/language_screen.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/widgets/category_filter_chip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  final String navigateTo;
  const CategoryScreen({super.key, required this.navigateTo});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String navigateTo;
  final GlobalKey<CategoryFilterChipState> _childKey =
      GlobalKey<CategoryFilterChipState>();

       @override
  void initState() {
    super.initState();
    navigateTo = widget.navigateTo;
  }

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
              CategoryFilterChip(key: _childKey),
              const SizedBox(height: 10.0),
              Consumer<FilterChipController>(
                builder: (context, controller, _) {
                  return Button(
                      buttonText:AppLocalizations.of(context)!.moreCategories,
                      isEnabled: controller.selectedCategories.isNotEmpty,
                      onPressed: () => _childKey.currentState
                          ?.safeFetchCategories(controller.selectedCategories));
                },
              ),
              const SizedBox(height: 10.0),
              Consumer<FilterChipController>(
                builder: (context, controller, _) {
                  return Button(
                      buttonText: AppLocalizations.of(context)!.next,
                      isEnabled: controller.selectedCategories.isNotEmpty,
                      onPressed: () {
                        if (navigateTo == "AudioList") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AudioListScreen()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LanguageSelectionScreen()),
                          );
                        }
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
