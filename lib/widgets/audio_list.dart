import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/language_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/models/audio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/services/controlled_generation.dart';

class AudioList extends StatelessWidget {
  final List<Audio> audios;

  const AudioList({super.key, required this.audios});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        return AudioTile(audio: audio);
      },
    ));
  }
}

class AudioTile extends StatelessWidget {
  final Audio audio;
  const AudioTile({super.key, required this.audio});
  static const int maxApiCalls = 3;

  @override
  Widget build(BuildContext context) {
    int apiCallCount = 0;

    Future<void> fetchScript(String title, String description) async {
      try {
        context.read<LoaderController>().showLoader();
        final languageController =
            Provider.of<LanguageController>(context, listen: false);
        String language = languageController.selectedLanguage!;
        String level = languageController.selectedLevel!;

        final response = await ControlledGeneration()
            .getAudioScript(title, description, language, level);
        print('Response: ${response}');


        // setState(() {
        //   allCategories = {
        //     ...allCategories,
        //     ...response,
        //   }.toList();
        // });

        apiCallCount++;
        debugPrint('API call count: $apiCallCount');
      } catch (e) {
        debugPrint('Error fetching related categories: $e');
      }
      context.read<LoaderController>().hideLoader();
    }

    bool shouldFetchScript() {
      final languageController =
          Provider.of<LanguageController>(context, listen: false);
      String? language = languageController.selectedLanguage;
      String? level = languageController.selectedLevel;

      if (apiCallCount >= maxApiCalls) {
        debugPrint('Maximum API call limit reached. Skipping API call.');
        return false;
      }

      if (language == null || language.isEmpty ) {
        debugPrint('language is empty');
        return false;
      }

      if (level == null || level.isEmpty) {
        debugPrint('language is empty');
        return false;
      }

      return true;
    }

    void safeFetchScript(String title, String description) {
      if (shouldFetchScript()) {
        fetchScript(title, description);
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Ink(
          decoration: const ShapeDecoration(
            color: Colors.blueAccent,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 30,
            color: Colors.white,
            onPressed: () {
              print("Reproduciendo audio: ${audio.title}");
            },
          ),
        ),
        title: Text(
          audio.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          audio.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          print("Seleccionaste el audio: ${audio.title}");
          safeFetchScript(audio.title, audio.description);
        },
      ),
    );
  }
}
