import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/language_controller.dart';
import 'package:test_app/screens/audio_list_screen.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/widgets/language_chip.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;

    final List<Map<String, String>> languages = [
      {
        'name': localizations.languageName_es,
        'flag': 'lib/assets/images/MX.png'
      },
      {
        'name': localizations.languageName_en,
        'flag': 'lib/assets/images/US.png'
      },
      {
        'name': localizations.languageName_fr,
        'flag': 'lib/assets/images/FR.png'
      },
      {
        'name': localizations.languageName_it,
        'flag': 'lib/assets/images/IT.png'
      },
    ];

      final List<String> proficiencyLevels = [
         localizations.beginner,
         localizations.intermediate,
         localizations.advanced
         ];

    return Scaffold(
        body: FutureBuilder(future: context.read<LanguageController>().loadLanguagesPreferences(),
        builder: (context, snapshot) {
          
          return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.selectLanguage,
                style: textTheme.titleLarge),
            const SizedBox(height: 20.0),
            Consumer<LanguageController>(builder: (context, controller, child) {
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 5.0,
                children: languages.map((language) {
                  return LanguageChoiceChip(
                    languageName: language['name']!,
                    imageAsset: language['flag']!,
                    isSelected: controller.selectedLanguage == language['name'],
                    onSelected: (isSelected) => controller.saveSelectedLanguage(isSelected)
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 50),
            Text(
              AppLocalizations.of(context)!.languageProficiencyTitle,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Consumer<LanguageController>(builder: (context, controller, child) {
              return Column(
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: proficiencyLevels.map((level) {
                      return ChoiceChip(
                        label: Text(level),
                        selected: controller.selectedLevel == level,
                        onSelected: (bool selected) => controller.saveSelectedLevel(selected ? level : '')
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Button(
                      buttonText: AppLocalizations.of(context)!.next,
                      isEnabled: controller.selectedLevel != null &&
                      controller.selectedLevel!.isNotEmpty &&
                          controller.selectedLanguage != null &&
                          controller.selectedLanguage!.isNotEmpty,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudioListScreen()),
                        );
                      })
                ],
              );
            }),
          ],
        ));
        })
        );
  }
}
