import 'dart:convert';

class Audio {
  final String title;
  final String description;

  Audio({
    required this.title,
    required this.description,
  });

   factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

   static List<Audio> fromJsonList(String jsonString) {
    return (json.decode(jsonString) as List)
        .map((item) => Audio.fromJson(item))
        .toList();
  }



  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Audio.fromPlainJson(String json) {
    final map = jsonDecode(json);
    return Audio.fromJson(map);
  }
}
