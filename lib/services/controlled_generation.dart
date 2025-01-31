import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:test_app/models/audio.dart';
import 'package:test_app/models/script.dart';

class ControlledGeneration {
  String apiKey = dotenv.env['GEN_KEY'] ?? "API Key not found";

  Future<List<String>> getCategories(
      String categories, String currentLocale, String currentCategories) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json', maxOutputTokens: 3000));

    final String prompt = '''
Genera una lista con un máximo de 15 sugerencias de categorías o géneros relacionadas con la Lista de temas. 
Distribuye las sugerencias lo más equitativamente posible entre los temas de la Lista de temas, priorizando la diversidad y respetando el limite.
La respuesta debe estar estructurada como un Array<String>.
Asegúrate de que el formato del array sea válido, sin comas al final o errores de sintaxis.
Cada elemento del array debe estar correctamente encerrado entre comillas dobles y separados únicamente por comas válidas dentro del array.
Cada string debe representar solo el nombre de una categoría en el idioma ${currentLocale}, cada categoría debe estar relacionada y ser siempre más especifica pero no puede ser sinonimo del tema. 
El nombre debe ser corto y conciso, por ejemplo 'Tecnologia', 'Entretenimiento', etc y no puede contenér más de 4 palabras.
Las sugerencias pueden incluir géneros, nombres específicos de productos, franquicias, bandas, artistas, o exponentes representativos de cada categoría.
Asegúrate de que las sugerencias estén muy relacionadas a los temas de la Lista de temas.
Asegúrate de que la lista generada no incluya valores repetidos.
Asegúrate de que la lista tenga un minimo de 10 sugerencias.
Asegúrate de que la lista generada represente a cada tema lo más equitativamente posible, la idea es que no predominen sugerencias solo de un tema, si no que contenga sugerencias de todos los temas de la Lista de temas de forma equitativa, por ejemplo, si la Lista de temas contiene dos temas, se espera que tu resultado contenga 5 sugerencias por cada tema.
Los nombres generados deben ser reales y conocidos dentro de los temas proporcionados.
Tu respuesta no debe incluir las mismas palabras que esta lista: ${currentCategories}.

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
    
    // print("prompt: ${prompt}");

    // final res = '["Tecnología móvil", "Videojuegos", "Cine"]';
    // return List<String>.from(json.decode(res));

    
  }

  Future<List<Audio>> getAudioList(
      String categories, String currentLocale, String level) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json', maxOutputTokens: 3000));

    final String prompt = '''
Genera una lista de hasta 5 elementos, donde cada elemento represente una opción de audio corto (menos de 5 minutos) diseñado como una charla casual o un episodio de podcast.
El Audio descrito en cada elemento de la lista debe ser adecuado para el nivel de proficiency ${level} en el idioma, por ejemplo, si el nivel es principiante, se espera que el Audio descrito contenga vocabulario básico, que no sea tan complejo ni tecnico, para que una persona con ese nivel sea capaz de entenderlo.
La respuesta debe estar estructurada como un Array de objetos, donde el objeto tiene las propiedades:

title: Un título que sea conciso y capture la esencia de la discusión del audio considerando que el tema que represente debe poder ser abordado en un audio de menos de 5 minutos, pero evita titulos que sean listas o compilaciones de ejemplos.
description: Una muy breve descripción (1 oración muy corta) que describa un único y principal tema lo suficientemente sencillo como para ser tratado en un estilo conversacional acorde al nivel de proficiency ${level} en menos de 5 minutos.

Asegúrate de que el formato del array sea válido, sin comas al final o errores de sintaxis.
Cada elemento del array debe estar correctamente escrito y separados únicamente por comas válidas dentro del array.
Asegúrate de que los títulos y descripciones estén muy relacionados con al menos una, pero preferentemente varias de las siguientes categorías, temas ó generos: ${categories}.
Asegúrate de que los títulos y descripciones reflejen temas atractivos, interesantes y adecuados para una discusión de menos de 5 minutos al estilo de una charla casual o un podcast.
Asegúrate de que los títulos y descripciones no reflejen nunca contenido en primera persona.
Evita que los titulos y descripciones sean listas o compilaciones de ejemplos de las categorias proporcionadas.
Asegurate de que los titulos y descripciones reflejen contenido diseñado para reforzar el estudio de un idioma acorde al nivel de proficiency ${level}.
Asegurate que los titulos y descripciones solo contengan temas que pueden ser abarcados en menos de 5 minutos, evita agregar temas muy extensos.
La lista debe estar escrita en ${currentLocale}.
''';
    final response = await model.generateContent([Content.text(prompt)]);
    print('Lista de Audios: ${response.text}');
    print('candidatesTokenCount: ${response.usageMetadata?.candidatesTokenCount}');
    print('promptTokenCount ${response.usageMetadata?.promptTokenCount}');
    print('totalTokenCount ${response.usageMetadata?.totalTokenCount}');
    print('candidates.length ${response.candidates.length}');
    print('promptFeedback ${response.promptFeedback}');

    // final res = '[{"title": "The Rise of Indie Games", "description": "We discuss the increasing popularity of independent video games and their impact on the gaming industry."}, {"title": "Music Streaming Wars: Spotify vs. Apple Music", "description": "A casual comparison of the two leading music streaming platforms, focusing on their key features and pricing."}, {"title": "Top 5 Productivity Apps for Students", "description": "We review five popular software applications designed to help students improve their organization and time management skills."}]';
    // final res = '[{"title": "Videojuegos indie: joyas ocultas", "description": "Exploramos algunos videojuegos indie interesantes y accesibles que ofrecen experiencias únicas y divertidas."}, {"title": "Música de los 80: sintetizadores y nostalgia", "description": "Recordamos la música de los 80, sus sintetizadores característicos y cómo ha influenciado la música actual."}, {"title": "Aplicaciones móviles que te harán la vida más fácil", "description": "Descubrimos aplicaciones para smartphones que pueden simplificar tareas cotidianas y mejorar nuestra productividad."}, {"title": "Streaming de música: Spotify vs. Apple Music", "description": "Comparamos dos plataformas populares de streaming de música, analizando sus ventajas y desventajas."}, {"title": "Software de edición de imágenes: opciones gratuitas y fáciles de usar", "description": "Revisamos algunas opciones de software gratuito para editar imágenes, ideal para principiantes."}]';
    if (response.text != null && response.text!.isNotEmpty) {
      final List<Audio> audioList = Audio.fromJsonList(response.text!);
      return audioList;
    }
    
    return [];
  }

  Future<AudioScript?> getAudioScript(
      String title, String description, String language, String level) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json', maxOutputTokens: 3000));

    final String prompt = '''
Genera un guión para una charla casual o un episodio de podcast corto, cuya duración debe ser de 3 minutos.
El guión debe ser adecuado para el nivel de proficiency ${level} en el idioma ${language}, por ejemplo, si el nivel es principiante, se espera que el Audio contenga vocabulario básico, que no sea tan complejo ni tecnico, para que una persona con ese nivel sea capaz de entenderlo.
La respuesta debe tener el siguiente formato y tipo:

{
  "title": "String",
  "description": "String",
  "speakers": ["String"],
  "script": [
    {
      "speaker": "String",
      "line": "String"
    }
  ]
}

El guión debe estár basado en el titulo: ${title} y la descripción:  ${description}.
Si la descripción no incluye la palabra podcast, episodio, o alguna otra palabra que explicitamente refleje que el contenido es un podcast, se deberá generar un guión para una charla casual.
El guión puede incluir géneros, nombres específicos de productos, franquicias, bandas, artistas, o exponentes representativos del tema.
El guión debe desarrollar el tema lo suficientemente sencillo como para ser tratado en un estilo conversacional acorde al nivel de proficiency ${level} en menos de 3 minutos.
Asegúrate de que la respuesta cumpla con esta estructura, sin desviarse del formato especificado.
Asegúrate de que el texto del guión sea válido, sin comas al final o errores de sintaxis.
Asegúrate de que los participantes solo tengan un nombre, sin apellidos.
Asegúrate de que si se trata de un podcast, que ninguno sea invitado, para evitar agradecimientos o lineas similare y vayan directo al tema.
Asegúrate de que el guión refleje el temas de forma atractiva, interesante y adecuados para una discusión de menos de 3 minutos al estilo de una charla casual o un podcast.
Asegúrate de que el guión no refleje nunca contenido en primera persona.
Asegurate de que el contenido del guión refleje contenido diseñado para reforzar el estudio del idioma ${language} acorde al nivel de proficiency ${level}.
En caso de que el nivel de proficiency sea avanzado, utiliza palabras contraídas o abreviadas, con la intención de que simule una interacción real.
Asegúrate de que el contenido dentro de cada line esté bien escrito, y no tenga errores ortograficos o gramaticales.
El guión debe reflejar una interacción muy realista y humana, y con una secuencia congruente.
El guión debe estar escrito en ${language}.
''';
    final response = await model.generateContent([Content.text(prompt)]);

    print('Guión: ${response.text}');
    print(
        'candidatesTokenCount: ${response.usageMetadata?.candidatesTokenCount}');
    print('promptTokenCount ${response.usageMetadata?.promptTokenCount}');
    print('totalTokenCount ${response.usageMetadata?.totalTokenCount}');
    print('candidates.length ${response.candidates.length}');
    print('promptFeedback ${response.promptFeedback}');

    if (response.text != null && response.text!.isNotEmpty) {
        final audioScript = AudioScript.fromJson(response.text!);
        return audioScript;
    }
    
    return null;
}

}