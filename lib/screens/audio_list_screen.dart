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

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  List<Audio> allAudios = [];

  // final List<Audio> audios = [
  //   Audio(
  //     title: 'Aprende Flutter',
  //     description: 'Un podcast sobre Flutter y desarrollo móvil.',
  //   ),
  //   Audio(
  //     title: 'Tecnología al Día',
  //     description: 'Noticias de tecnología y tendencias actuales.',
  //   ),
  //   Audio(
  //     title: 'Historia del Mundo',
  //     description: 'Explora la historia a través de relatos fascinantes.',
  //   ),
  //   // Agrega más audios aquí...
  // ];

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


  @override
  Widget build(BuildContext context) {
    print('build');
    Future<void> fetchAudioList() async {
       final audioController = Provider.of<AudioController>(context, listen: false);
       
      final loaderController =
          Provider.of<LoaderController>(context, listen: false);
      loaderController.showLoader();
      print('showLoader');
      try {
        final categoryController =
            Provider.of<FilterChipController>(context, listen: false);
        final languageController =
            Provider.of<LanguageController>(context, listen: false);
        String categories = categoryController.selectedCategories.length > 1
            ? categoryController.selectedCategories.join(', ')
            : categoryController.selectedCategories.first;
        final currentLocale = AppLocalizations.of(context)?.localeName ?? '';
        print('Categories: ${categories}');
        print('level: ${languageController.selectedLevel}');
        print('Language to Display: ${currentLocale}');

        final response = await ControlledGeneration().getAudioList(
            categories, currentLocale, languageController.selectedLevel ?? '');

        print("response: ${response}");

        audioController.audioList = [...audioController.audioList, ...response];
        await audioController.saveAudioList();

        setState(() {
          allAudios = {...allAudios, ...response}.toList();
        });
      } catch (e) {
        debugPrint('Error fetching audioList: ${e}');
      }
      // context.read<LoaderController>().hideLoader();
      loaderController.hideLoader();
      print('hideLoader');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audioListTitle),
      ),
      body:
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          // child:
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AudioList(audios: allAudios.toList()),
            SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () async {
                await fetchAudioList();
              },
              child: Text('Genera lista de Audios'),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
      // ),
    );
  }
}
