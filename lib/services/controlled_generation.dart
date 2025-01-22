import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ControlledGeneration {
  String apiKey = dotenv.env['GEN_KEY'] ?? "API Key not found";

  Future<List<String>> getCategories(String categories, String currentLocale) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'));

    final String prompt = '''
Genera una lista de categorías o géneros relacionadas con la Lista de temas. 
Limita tu respuesta a un máximo de 4 categorías. 
La respuesta debe estar estructurada como un Array<String>

Cada string debe representar solo el nombre de una categoría en el idioma ${currentLocale}, cada categoría debe estar relacionada y ser siempre más especifica. 
El nombre debe ser corto y conciso, por ejemplo 'Tecnologia', 'Entretenimiento', etc.
Puedes incluir tambien géneros si aplica la relación con el tema, por ejemplo si el tema es 'Musica' el género como respuesta podría ser 'Rock'.
Tu respuesta no debe incluir las mismas palabras que la lista de temas.

Lista de temas: ${categories}
''';
    final response = await model.generateContent([Content.text(prompt)]);
    print('Categorias: ${response.text}');
    print('candidatesTokenCount: ${response.usageMetadata?.candidatesTokenCount}');
    print('promptTokenCount ${response.usageMetadata?.promptTokenCount}');
    print('totalTokenCount ${response.usageMetadata?.totalTokenCount}');
    print('candidates.length ${response.candidates.length}');
    print('promptFeedback ${response.promptFeedback}');

    return List<String>.from(json.decode(response.text ?? ''));
  }

  Future<List<String>> getAudioList(String categories, String currentLocale) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'));

    final String prompt = '''
Genera una lista de categorías o géneros relacionadas con la Lista de temas. 
Limita tu respuesta a un máximo de 4 categorías. 
La respuesta debe estar estructurada como un Array<String>

Cada string debe representar solo el nombre de una categoría en el idioma ${currentLocale}, cada categoría debe estar relacionada y ser siempre más especifica. 
El nombre debe ser corto y conciso, por ejemplo 'Tecnologia', 'Entretenimiento', etc.
Puedes incluir tambien géneros si aplica la relación con el tema, por ejemplo si el tema es 'Musica' el género como respuesta podría ser 'Rock'.
Tu respuesta no debe incluir las mismas palabras que la lista de temas.

Lista de temas: ${categories}
''';
    final response = await model.generateContent([Content.text(prompt)]);
    print('Categorias: ${response.text}');
    print('candidatesTokenCount: ${response.usageMetadata?.candidatesTokenCount}');
    print('promptTokenCount ${response.usageMetadata?.promptTokenCount}');
    print('totalTokenCount ${response.usageMetadata?.totalTokenCount}');
    print('candidates.length ${response.candidates.length}');
    print('promptFeedback ${response.promptFeedback}');

    return List<String>.from(json.decode(response.text ?? ''));
  }
}
