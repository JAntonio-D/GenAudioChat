import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  // Parámetros que recibirá el botón: texto, estilo y una acción cuando se presiona.
  final String buttonText;
  final TextStyle? textStyle;
  final VoidCallback onPressed; // Acción cuando se presiona el botón
  final bool isEnabled;

  // Constructor para recibir estos parámetros
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
      onPressed: isEnabled ? onPressed : null, // Acción al presionar
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.blue,
        textStyle: textStyle, // Estilo del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ), // Color del texto por defecto
      ),
      child: Text(buttonText), // Texto que recibimos como parámetro
    );
  }
}
