import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final TextStyle? textStyle;
  final VoidCallback onPressed;
  final bool isEnabled;

  const Button({
    required this.buttonText,
    required this.onPressed,
    this.textStyle,
    this.isEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.blue,
        textStyle: textStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
