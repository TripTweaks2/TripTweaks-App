import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedText extends StatelessWidget {
  const RoundedText({
    Key? key,
    this.width,
    required this.text,
    this.textStyle,
    this.backgroundColor = Colors.lightBlue, // Color de fondo predeterminado
    this.borderRadius = 8.0, // Radio de borde predeterminado
  }) : super(key: key);

  final double? width;
  final String text;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width,
        height: 15,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: textStyle ?? TextStyle(color: Colors.white, fontSize: 13),
            textAlign: TextAlign.center, // Asegura que el texto esté centrado horizontalmente
          ),
        ),
      ),
    );
  }
}