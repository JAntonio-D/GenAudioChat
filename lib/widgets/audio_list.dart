import 'package:flutter/material.dart';
import 'package:test_app/models/audio.dart';


class AudioList extends StatelessWidget {
  final List<Audio> audios;

  const AudioList({super.key, required this.audios});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        return AudioTile(audio: audio);
      },
    );
  }
}

class AudioTile extends StatelessWidget {
  final Audio audio;

  const AudioTile({super.key, required this.audio});

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
                print("Reproduciendo audio: ${audio.title}");
            },
          ),
        ),
        title: Text(
          audio.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          audio.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          print("Seleccionaste el audio: ${audio.title}");
        },
      ),
    );
  }
}
