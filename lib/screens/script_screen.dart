// lib/screens/script_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:test_app/models/script.dart';
import 'package:test_app/widgets/script_line.dart';

class ScriptChatScreen extends StatelessWidget {
  final AudioScript script;

  const ScriptChatScreen({super.key, required this.script});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(script.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: script.script.length,
          itemBuilder: (context, index) {
            ScriptLine scriptLine = script.script[index];
            bool isSpeaker1 = scriptLine.speaker == script.speakers[0];

            return ChatMessage(
              isSpeaker1: isSpeaker1,
              speaker: scriptLine.speaker,
              line: scriptLine.line,
            );
          },
        ),
      ),
    );
  }
}
