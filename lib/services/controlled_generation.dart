import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ControlledGeneration {
  String apiKey = dotenv.env['GEN_KEY'] ?? "API Key not found";

  Future<void> getCategories() async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'));

    final String prompt = '''
Genera una lista de categorías de temas generales e interesantes de actualidad, incluyendo temas de interés social y tendencias actuales. Los temas deben abarcar áreas como Tecnología, Ciencia, Entretenimiento, Política, Cultura, etc. Limita la lista a un máximo de 3 categorías. La respuesta debe estar estructurada como un JSON con el siguiente formato:
'Category = { "categoryName": string}'
'Return: Array<Category>'

Cada objeto dentro del array debe representar una categoría general de interés, pero deben ser muy generales, no especificos, y el valor de "categoryName" representa solo el nombre de la categoría y debe ser corto y conciso, por ejemplo 'Tecnologia', 'Entretenimiento', etc.
''';
    final response = await model.generateContent([Content.text(prompt)]);
    print('Categorias: ${response.text}');
    print('candidatesTokenCount: ${response.usageMetadata?.candidatesTokenCount}');
    print('promptTokenCount ${response.usageMetadata?.promptTokenCount}');
    print('totalTokenCount ${response.usageMetadata?.totalTokenCount}');
    print('candidates.length ${response.candidates.length}');
    print('promptFeedback ${response.promptFeedback}');
  }
}
