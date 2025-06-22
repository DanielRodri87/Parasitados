import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class ArcTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  ArcTextPainter({required this.text, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height * 2.0;
    final angleStart = -pi / 1.32;
    final angleSweep = pi / 1.85;

    final anglePerChar = angleSweep / (text.length - 1);

    canvas.translate(size.width / 2, size.height * 2.2);

    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final angle = angleStart + i * anglePerChar;

      final x = radius * cos(angle);
      final y = radius * sin(angle);

      final charPainter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      charPainter.layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + pi / 2); // gira a letra para acompanhar o arco
      charPainter.paint(
        canvas,
        Offset(-charPainter.width / 2, -charPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
