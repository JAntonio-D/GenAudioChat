import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:test_app/controllers/audio_player_controller.dart';

import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List combinedAudio;

  const AudioPlayerWidget({super.key, required this.combinedAudio});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = AudioPlayerController();
    controller.setAudio(widget.combinedAudio);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _playPauseButton(PlayerState playerState) {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: CircularProgressIndicator(),
      );
    } else if (controller.isPlaying != true) {
      return IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 40.0,
        onPressed: controller.playAudio,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: Icon(Icons.pause),
        iconSize: 40.0,
        onPressed: controller.pauseAudio,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.replay),
        iconSize: 40.0,
        onPressed: () {
          replayAudio();
        },
      );
    }
  }

  void replayAudio() {
    controller.audioPlayer.seek(Duration.zero);
    controller.audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<PlayerState>(
            stream: controller.audioPlayer.playerStateStream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Icon(Icons.error);
              }

              final playerState = snapshot.data;
              return _playPauseButton(playerState!);
            },
          )
        ],
      ),
    );
  }
}
