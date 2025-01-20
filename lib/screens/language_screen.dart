import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/screens/podcast_list_screen.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/widgets/language_chip.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

// Segunda pantalla a la que navegaremos
class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // Lista de idiomas con su código, nombre y ruta de la bandera

  // Variable para almacenar el idioma seleccionado
  String? _selectedLanguage;
  String? _selectedLevel;

  final List<String> proficiencyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<Map<String, String>> languages = [
      {
        'code': 'es',
        'name': AppLocalizations.of(context)!.languageName_es,
        'flag': 'lib/assets/images/MX.png'
      },
      {
        'code': 'en',
        'name': AppLocalizations.of(context)!.languageName_en,
        'flag': 'lib/assets/images/US.png'
      },
      {
        'code': 'fr',
        'name': AppLocalizations.of(context)!.languageName_fr,
        'flag': 'lib/assets/images/FR.png'
      },
      {
        'code': 'it',
        'name': AppLocalizations.of(context)!.languageName_it,
        'flag': 'lib/assets/images/IT.png'
      },
      // Puedes agregar más idiomas aquí...
    ];

    return Scaffold(
      appBar: AppBar(
          // title: const Text("Segunda Pantalla"),
          ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(AppLocalizations.of(context)!.selectLanguage,
              style: textTheme.titleLarge),
          const SizedBox(height: 5.0),
          Wrap(
            spacing: 5.0,
            children: languages.map((language) {
              return LanguageChoiceChip(
                languageCode: language['code']!,
                languageName: language['name']!,
                imageAsset: language['flag']!,
                isSelected: _selectedLanguage == language['code'],
                onSelected: (String languageCode) {
                  setState(() {
                    _selectedLanguage =
                        languageCode.isNotEmpty ? languageCode : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10.0),
          // Usamos el método para crear los ChoiceChips a partir de la lista de idiomas
          // Muestra el idioma seleccionado
          if (_selectedLanguage != null)
            Text('Idioma seleccionado: $_selectedLanguage'),
          SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.languageProficiencyTitle,
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: proficiencyLevels.map((level) {
              return ChoiceChip(
                label: Text(level),
                selected: _selectedLevel == level,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedLevel = selected ? level : null;
                  });
                },
              );
            }).toList(),
          ),
          Button(
              buttonText: "Next",
              isEnabled: _selectedLanguage != null && _selectedLevel != null,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PodcastListScreen()),
                );
              })
        ],
      )),
    );
  }
}
