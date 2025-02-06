import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/audio_controller.dart';
import 'package:test_app/controllers/audio_player_controller.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/controllers/language_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/screens/audio_list_screen.dart';
import 'package:test_app/screens/category_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/widgets/global_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loaderController = LoaderController();
  final categoryController = FilterChipController();
  final languageController = LanguageController();
  final audioController = AudioController();
  final audioPlayerController = AudioPlayerController();

  loaderController.showLoader();
  await dotenv.load();

  await Future.wait([
    categoryController.loadSelectedCategories(),
    languageController.loadLanguagesPreferences(),
    audioController.loadAudioList(),
    audioController.loadAudioScriptList(),
  ]);

  loaderController.hideLoader();
  bool isConfigurationCompleted =
      categoryController.selectedCategories.isNotEmpty &&
          languageController.selectedLanguage != null &&
          languageController.selectedLanguage!.isNotEmpty &&
          languageController.selectedLevel != null &&
          languageController.selectedLevel!.isNotEmpty;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => categoryController),
        ChangeNotifierProvider(create: (_) => loaderController),
        ChangeNotifierProvider(create: (_) => languageController),
        ChangeNotifierProvider(create: (_) => audioController),
        ChangeNotifierProvider(create: (_) => audioPlayerController),
      ],
      child: MyApp(isConfigurationCompleted: isConfigurationCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isConfigurationCompleted;
  const MyApp({super.key, required this.isConfigurationCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Stack(
        children: [
          isConfigurationCompleted
              ? AudioListScreen()
              : CategoryScreen(navigateTo: ""),
          GlobalLoader(),
        ],
      ),
    );
  }
}
