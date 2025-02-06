import 'dart:convert';

class ScriptLine {
  final String speaker;
  final String line;

  ScriptLine({
    required this.speaker,
    required this.line,
  });

  factory ScriptLine.fromJson(Map<String, dynamic> json) {
    return ScriptLine(
      speaker: json['speaker'],
      line: json['line'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'line': line,
    };
  }
}

class AudioScript {
  final String title;
  final String description;
  final List<String> speakers;
  final List<ScriptLine> script;

  AudioScript({
    required this.title,
    required this.description,
    required this.speakers,
    required this.script,
  });

  factory AudioScript.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);

    List<ScriptLine> scriptList = (json['script'] as List)
        .map((item) => ScriptLine.fromJson(item))
        .toList();

    return AudioScript(
      title: json['title'],
      description: json['description'],
      speakers: List<String>.from(json['speakers']),
      script: scriptList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'speakers': speakers,
      'script': script.map((line) => line.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  AudioScript copyWith(
      {String? title,
      String? description,
      List<String>? speakers,
      List<ScriptLine>? script}) {
    return AudioScript(
      title: title ?? this.title,
      description: description ?? this.description,
      speakers: speakers ?? this.speakers,
      script: script ?? this.script,
    );
  }
}
