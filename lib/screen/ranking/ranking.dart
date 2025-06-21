import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

void main() {
  runApp(const MaterialApp(home: RankingScreen()));
}

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/backRanking.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Cabeçalho
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Parasitados',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        'Descubra seus dons conosco!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Pulga
                Image.asset(
                  'assets/images/pulgo.png',
                  height: 200,
                ),
                const SizedBox(height: 16),
                // LadoPar e Texto
                SizedBox(
                  height: 80,
                  child: CustomPaint(
                    painter: ArcTextPainter(
                      text: 'LADOPAR',
                      textStyle: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Shrikhand',
                        letterSpacing: 2,
                      ),
                    ),
                    size: const Size(300, 80),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Você ficou no top 3% no\nParasitados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YoungSerif',
                  ),
                ),
                const SizedBox(height: 24),
                const Spacer(), // Adiciona um spacer para empurrar os cards para baixo
                // Cartões de métricas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      MetricCard(
                        icon: 'assets/images/rankingrank.png',
                        label: 'Top 3%',
                        sublabel: 'Rank',
                      ),
                      MetricCard(
                        icon: 'assets/images/pontorank.png',
                        label: '97%',
                        sublabel: 'Taxa de acertos',
                      ),
                      MetricCard(
                        icon: 'assets/images/raiorank.png',
                        label: '23 Acertos',
                        sublabel: 'Desempenho',
                      ),
                      MetricCard(
                        icon: 'assets/images/relogiorank.png',
                        label: '14:57 min',
                        sublabel: 'Tempo Jogado',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32), // Aumenta o espaçamento inferior
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String icon;
  final String label;
  final String sublabel;

  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 32,
            height: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            sublabel,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class ArcTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  ArcTextPainter({
    required this.text,
    required this.textStyle,
  });

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