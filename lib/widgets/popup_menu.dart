import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/screens/category_screen.dart';
import 'package:test_app/screens/language_screen.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings),
      onSelected: (value) {
        if (value == 'config') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
          );
        } else if (value == 'categories') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryScreen(navigateTo: "AudioList",)),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'config',
            child: Text(AppLocalizations.of(context)!.settings),
          ),
          PopupMenuItem<String>(
            value: 'categories',
            child: Text(AppLocalizations.of(context)!.explore_categories),
          ),
        ];
      },
    );
  }
}
