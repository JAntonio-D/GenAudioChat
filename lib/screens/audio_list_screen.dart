import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/widgets/audio_list.dart';

class AudioListScreen extends StatelessWidget {
  AudioListScreen({super.key});

  final List<Audio> audios = [
    Audio(
      title: 'Aprende Flutter',
      description: 'Un podcast sobre Flutter y desarrollo móvil.',
    ),
    Audio(
      title: 'Tecnología al Día',
      description: 'Noticias de tecnología y tendencias actuales.',
    ),
    Audio(
      title: 'Historia del Mundo',
      description: 'Explora la historia a través de relatos fascinantes.',
    ),
    // Agrega más audios aquí...
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.audioListTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AudioList(audios: audios),
        ),
      ),
    );
  }
}
