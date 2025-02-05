import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/audio_controller.dart';
import 'package:test_app/models/audio_bytes.dart';
import 'package:test_app/models/script.dart';
import 'package:test_app/services/audio_service.dart';
import 'package:test_app/services/controlled_generation.dart';
import 'package:test_app/widgets/audio_player.dart';
import 'package:test_app/widgets/script_line.dart';

class ScriptChatScreen extends StatefulWidget {
  final AudioScript audioScript;

  const ScriptChatScreen({super.key, required this.audioScript});

  @override
  _ScriptChatScreenState createState() => _ScriptChatScreenState();
}

class _ScriptChatScreenState extends State<ScriptChatScreen> {
  List<Uint8List> audioBytes = [];
  bool _isLoading = true;
  bool _isFinished = false;
  late Uint8List combinedAudio;
  int apiCallCount = 0;
  static const int maxApiCalls = 1;

  @override
  void initState() {
    super.initState();
    getAudioBytes();
  }

  Future<Uint8List?> findAudioBytes(String title) async {
    try {
      final audioController =
          Provider.of<AudioController>(context, listen: false);
      if (audioController.audioBytesList.isEmpty) {
        return null;
      }
      await audioController.loadAudioBytes();

      final bytes = audioController.findBytes(title);
      return bytes;
    } catch (e) {
      debugPrint('Error finding bytes: $e');
      return null;
    }
  }

  bool shouldFetchBytes() {
    if (apiCallCount >= maxApiCalls) {
      debugPrint('Maximum API call limit reached. Skipping API call.');
      setState(() {
        _isLoading = false;
        _isFinished = false;
      });
      return false;
    }
    if (widget.audioScript.title.isEmpty) {
      debugPrint('title is empty');
      setState(() {
        _isLoading = false;
        _isFinished = false;
      });
      return false;
    }
    return true;
  }

  Future<void> getAudioBytes() async {
    final bytes = await findAudioBytes(widget.audioScript.title);
    if (bytes != null) {
      combinedAudio = bytes;
      setState(() {
        _isLoading = false;
        _isFinished = true;
      });
    } else if (shouldFetchBytes()) {
      await fetchAudioBytes();
    }
  }

  Future<void> fetchAudioBytes() async {
    try {
      // mock 1
      // final audioData = await ControlledGeneration().textToSpeech("1", "");
      //   audioBytes.add(audioData);

      //mock all
      for (int i = 1; i < 4; i++) {
        final audioData =
            await ControlledGeneration().textToSpeech(i.toString(), "");
        audioBytes.add(audioData);
        apiCallCount++;
      }

      // all real
      // int counter = 0;
      // for (var scriptLine in widget.audioScript.script) {
      //   if (counter >= 1) break;

      //   final audioData = await ControlledGeneration()
      //       .textToSpeech(scriptLine.line, scriptLine.speaker);

      //   audioBytes.add(audioData);
      //   counter++;
      //   apiCallCount++;
      // }

      // one by one
      // final line1 = widget.audioScript.script[0];
      // final audioData =
      //     await ControlledGeneration().textToSpeech(line1.line, line1.speaker);
      // audioBytes.add(audioData);

      combinedAudio = combineAudio(audioBytes);

      if (combinedAudio.isNotEmpty) {
        final audioController =
            Provider.of<AudioController>(context, listen: false);

        final audio = AudioBytes(
            title: widget.audioScript.title,
            description: widget.audioScript.description,
            bytes: combinedAudio);

        audioController.audioBytesList.add(audio);
        await audioController.saveAudioBytes();
      }

      setState(() {
        _isLoading = false;
        _isFinished = true;
      });
    } catch (e) {
      debugPrint('Error fetching textToSpeech: $e');
      setState(() {
        _isLoading = false;
        _isFinished = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioScript.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(bottom: 100, left: 8, right: 8),
            child: Column(
              children:
                  List.generate(widget.audioScript.script.length, (index) {
                ScriptLine scriptLine = widget.audioScript.script[index];
                bool isSpeaker1 =
                    scriptLine.speaker == widget.audioScript.speakers[0];

                return ChatMessage(
                  isSpeaker1: isSpeaker1,
                  speaker: scriptLine.speaker,
                  line: scriptLine.line,
                );
              }),
            ),
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _isLoading
                ? Text('LOADING')
                : _isFinished
                    ? AudioPlayerWidget(
                        combinedAudio: combinedAudio,
                      )
                    : Text('ERROR LOADING :('),
          ),
        ],
      ),
    );
  }
}
