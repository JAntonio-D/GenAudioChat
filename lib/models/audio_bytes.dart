import 'dart:convert';
import 'dart:typed_data';

import 'package:test_app/models/audio.dart';

class AudioBytes extends Audio {
  final Uint8List bytes;

  AudioBytes(
      {required super.title, required super.description, required this.bytes});

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'bytes': base64Encode(bytes),
    };
  }

  factory AudioBytes.fromMap(Map<String, dynamic> map) {
    return AudioBytes(
      title: map['title'],
      description: map['description'],
      bytes: base64Decode(map['bytes']),
    );
  }
}
