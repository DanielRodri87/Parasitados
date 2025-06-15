import 'package:flutter/material.dart';

class BalloonPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;
  final double tailHeight;
  final double tailWidth;
  final double borderWidth;

  BalloonPainter({
    this.fillColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderRadius = 12.0,
    this.tailHeight = 20.0,
    this.tailWidth = 12.0,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Balão principal (retângulo arredondado)
    final bodyRect = Rect.fromLTWH(tailWidth, 0, size.width - tailWidth, size.height);
    final rrect = RRect.fromRectAndRadius(bodyRect, Radius.circular(borderRadius));

    // Balão preenchido
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, fillPaint);

    // Bordas do balão
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(rrect, borderPaint);

    // Seta do lado esquerdo, ponta para fora
	final path = Path();
	final centerY = size.height / 2;
	// A ponta da seta fica em (0, size.height - 20)
	// Responsivo: calcula a posição da seta proporcional ao tamanho do balão
	final tipX = -tailWidth * 0.7; // ponta da seta um pouco para fora
	final tipY = size.height * 0.38; // 75% da altura (ajuste conforme desejado)
	final baseTopY = (centerY + tailHeight / 2) * 0.22;
	final baseBottomY = (centerY - tailHeight / 2) * 0.80;

	path.moveTo(tipX, tipY); // ponta da seta (fora do balão)
	path.lineTo(tailWidth, baseBottomY); // base inferior da seta, encostada no balão
	path.lineTo(tailWidth, baseTopY); // base superior da seta, encostada no balão
	path.close();
	canvas.drawPath(path, fillPaint);
	canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
