import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ControlledGeneration {
  String apiKey = dotenv.env['GEN_KEY'] ?? "API Key not found";

  Future<List<String>> getCategories(String categories) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'));

    final String prompt = '''
Genera una lista de categorías o temas especificos relacionados con ${categories}, tu respuesta debe ser en el mismo idioma que estos temas. Limita la lista a un máximo de 3 categorías. La respuesta debe estar estructurada como un Array<String>

Cada string dentro del array debe representar solo el nombre de una categoría relacionada y debe ser corto y conciso, por ejemplo 'Tecnologia', 'Entretenimiento', etc.
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
