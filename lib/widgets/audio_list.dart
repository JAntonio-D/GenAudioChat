import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/audio_controller.dart';
import 'package:test_app/controllers/language_controller.dart';
import 'package:test_app/controllers/loader_controller.dart';
import 'package:test_app/models/audio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/models/script.dart';
import 'package:test_app/screens/script_screen.dart';
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
  static const int maxApiCalls = 1;

  @override
  Widget build(BuildContext context) {
    int apiCallCount = 0;

    AudioScript? findScript(String title) {
      try {
        final audioController =
            Provider.of<AudioController>(context, listen: false);
        if (audioController.audioScriptList.isEmpty) {
          return null;
        }

        return audioController.findScript(title);
      } catch (e) {
        debugPrint('Error finding script: $e');
        return null;
      }
    }

    Future<AudioScript?> fetchScript(String title, String description) async {
      try {
        context.read<LoaderController>().showLoader();

        final audioController =
            Provider.of<AudioController>(context, listen: false);

        final languageController =
            Provider.of<LanguageController>(context, listen: false);
        String language = languageController.selectedLanguage!;
        String level = languageController.selectedLevel!;

        final response = await ControlledGeneration()
            .getAudioScript(title, description, language, level);

        if (response != null) {         
          audioController.audioScriptList.add(response.copyWith(title: title));
          await audioController.saveAudioScriptList();
        }

        apiCallCount++;
        context.read<LoaderController>().hideLoader();
        return response;
      } catch (e) {
        context.read<LoaderController>().hideLoader();
        debugPrint('Error fetching script: $e');
      }
      return null;
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

      if (language == null || language.isEmpty) {
        debugPrint('language is empty');
        return false;
      }

      if (level == null || level.isEmpty) {
        debugPrint('level is empty');
        return false;
      }

      return true;
    }

    Future<AudioScript?> safeFetchScript(
        String title, String description) async {
      final script = findScript(title);
      if (script != null) {
        return script;
      }

      if (shouldFetchScript()) {
        return await fetchScript(title, description);
      }
      return null;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
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
        onTap: () async {
          final script = await safeFetchScript(audio.title, audio.description);
          if (script != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScriptChatScreen(audioScript: script)),
            );
          }
        },
      ),
    );
  }
}
