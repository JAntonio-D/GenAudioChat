import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

Uint8List combineAudio(List<Uint8List> audioParts) {
  final combinedAudio = <int>[];

  for (var part in audioParts) {
    combinedAudio.addAll(part);
  }

  return Uint8List.fromList(combinedAudio);
}
