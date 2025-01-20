import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/models/podcast.dart';
import 'package:test_app/widgets/podcast_list.dart';

class PodcastListScreen extends StatelessWidget {
  PodcastListScreen({super.key});
    // Lista de ejemplos de podcasts
  final List<Podcast> podcasts = [
    Podcast(
      title: 'Aprende Flutter',
      description: 'Un podcast sobre Flutter y desarrollo móvil.',
    ),
    Podcast(
      title: 'Tecnología al Día',
      description: 'Noticias de tecnología y tendencias actuales.',
    ),
    Podcast(
      title: 'Historia del Mundo',
      description: 'Explora la historia a través de relatos fascinantes.',
    ),
    // Agrega más podcasts aquí...
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.podcastListTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: PodcastList(podcasts: podcasts),
        ),
      ),
    );
  }
}
