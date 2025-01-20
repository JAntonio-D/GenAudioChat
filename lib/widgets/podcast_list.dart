// widgets/podcast_list_widget.dart
import 'package:flutter/material.dart';
import 'package:test_app/models/podcast.dart';


class PodcastList extends StatelessWidget {  // Cambié el nombre aquí a PodcastList (sin 'Widget')
  final List<Podcast> podcasts;

  const PodcastList({super.key, required this.podcasts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: podcasts.length,
      itemBuilder: (context, index) {
        final podcast = podcasts[index];
        return PodcastTile(podcast: podcast); // Usamos el widget PodcastTile
      },
    );
  }
}

class PodcastTile extends StatelessWidget { // PodcastTile sigue igual
  final Podcast podcast;

  const PodcastTile({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
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
                print("Reproduciendo podcast: ${podcast.title}");
            },
          ),
        ),
        title: Text(
          podcast.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          podcast.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          print("Seleccionaste el podcast: ${podcast.title}");
        },
      ),
    );
  }
}
