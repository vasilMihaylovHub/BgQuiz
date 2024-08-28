import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration? textDecoration;
  // final bool obscureText;

  const MyTextField({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 14,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).colorScheme.inversePrimary,
        decoration: textDecoration,
        decorationColor: Theme.of(context).colorScheme.inversePrimary
      ),
    );
  }
}
