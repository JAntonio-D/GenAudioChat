import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/audio_controller.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/controllers/language_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/services/controlled_generation.dart';
import 'package:test_app/widgets/audio_list.dart';
import 'package:test_app/widgets/popup_menu.dart';

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  List<Audio> allAudios = [];
  int maxApiCalls = 2;
  int apiCallCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAudioList();
    });
  }

  Future<void> _initializeAudioList() async {
    final controller = context.read<AudioController>();

    await controller.loadAudioList();
    setState(() {
      allAudios = {
        ...controller.audioList,
      }.toList();
    });
  }

  String getCategories() {
    final categoryController =
        Provider.of<FilterChipController>(context, listen: false);

    return categoryController.selectedCategories.length > 1
        ? categoryController.selectedCategories.join(', ')
        : categoryController.selectedCategories.first;
  }

  String getTitleList() {
    if (allAudios.isNotEmpty) {
      return allAudios.map((audio) => audio.title).join(', ');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Future<void> fetchAudioList() async {
      final audioController =
          Provider.of<AudioController>(context, listen: false);

      final loaderController =
          Provider.of<LoaderController>(context, listen: false);
      loaderController.showLoader();
      try {
        final languageController =
            Provider.of<LanguageController>(context, listen: false);
        final currentLocale = AppLocalizations.of(context)?.localeName ?? '';
        final categories = getCategories();
        final currentTitles = getTitleList();

        final response = await ControlledGeneration().getAudioList(
            categories,
            currentLocale,
            languageController.selectedLevel ?? '',
            currentTitles);

        audioController.audioList = [...audioController.audioList, ...response];
        await audioController.saveAudioList();

        setState(() {
          allAudios = {...allAudios, ...response}.toList();
        });
        apiCallCount++;
      } catch (e) {
        debugPrint('Error fetching audioList: ${e}');
      }
      loaderController.hideLoader();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audioListTitle),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenu(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AudioList(audios: allAudios.toList()),
            SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: apiCallCount >= maxApiCalls
                  ? null
                  : () async {
                      await fetchAudioList();
                    },
              child: Text(AppLocalizations.of(context)!.getAudioList),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
      // ),
    );
  }
}
