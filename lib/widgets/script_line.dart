import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final bool isSpeaker1;
  final String speaker;
  final String line;

  const ChatMessage({
    super.key,
    required this.isSpeaker1,
    required this.speaker,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSpeaker1 ? Alignment.centerLeft : Alignment.centerRight,
      child: Card(
        color: isSpeaker1
            ? Color.fromARGB(255, 173, 182, 196)
            : Color.fromARGB(255, 58, 80, 107),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
                isSpeaker1 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                speaker,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSpeaker1 ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                line,
                style: TextStyle(
                  color: isSpeaker1 ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
