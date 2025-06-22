import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: isSmallScreen ? 4.0 : 8.0,
              top: isSmallScreen ? 4.0 : 8.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                    border: Border.all(color: Colors.white.withAlpha(51)),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: isSmallScreen ? 16 : 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section com design futurista responsivo
            SizedBox(
              width: double.infinity,
              height: isSmallScreen 
                ? screenSize.height * 0.45
                : isMediumScreen 
                  ? screenSize.height * 0.48
                  : screenSize.height * 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(126, 218, 132, 1),
                      Color.fromRGBO(87, 181, 203, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Efeito de grade tecnológica
                    Positioned.fill(
                      child: CustomPaint(
                        painter: TechGridPainter(
                          gridSize: isSmallScreen ? 20 : isMediumScreen ? 25 : 30,
                        ),
                      ),
                    ),
                    // Conteúdo principal
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo com efeito de glow responsivo
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(38),
                                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : isMediumScreen ? 16 : 20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(76),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withAlpha(25),
                                    blurRadius: isSmallScreen ? 10 : isMediumScreen ? 15 : 20,
                                    spreadRadius: isSmallScreen ? 2 : isMediumScreen ? 3 : 5,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/carraputo.png',
                                height: isSmallScreen ? 50 : isMediumScreen ? 65 : 80,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : isMediumScreen ? 16 : 20),
                            
                            // Título com efeito moderno responsivo
                            Column(
                              children: [
                                Text(
                                  '🔬 LABORATÓRIO DE EXCELÊNCIA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 16 : isMediumScreen ? 19 : 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: isSmallScreen ? 0.5 : 1,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isSmallScreen ? 4 : 8),
                                Text(
                                  'Pesquisa & Inovação em Parasitologia',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 12 : isMediumScreen ? 14 : 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: isSmallScreen ? 0.2 : 0.5,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 10),

                            // Botões sociais modernos responsivos
                            Flexible(
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                spacing: isSmallScreen ? 4 : 8,
                                runSpacing: isSmallScreen ? 4 : 8,
                                children: [
                                  ModernSocialButton(
                                    icon: Icons.camera_alt,
                                    label: 'Instagram',
                                    onTap: () => launchUrl(Uri.parse('https://www.instagram.com/ladopar.nezoon/')),
                                    isSmallScreen: isSmallScreen,
                                  ),
                                  ModernSocialButton(
                                    icon: Icons.email_outlined,
                                    label: 'E-mail',
                                    onTap: () => launchUrl(Uri.parse('mailto:techkua@gmail.com')),
                                    isSmallScreen: isSmallScreen,
                                  ),
                                  ModernSocialButton(
                                    icon: Icons.code,
                                    label: 'GitHub',
                                    onTap: () => launchUrl(Uri.parse('https://github.com/Kua-Tech')),
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Seção do Pulgo com design card moderno responsivo
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : isMediumScreen ? 16 : 20,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16 : isMediumScreen ? 20 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: isSmallScreen ? 10 : isMediumScreen ? 15 : 20,
                      offset: Offset(0, isSmallScreen ? 5 : 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Pulgo com container moderno responsivo
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(126, 218, 132, 0.1),
                            Color.fromRGBO(87, 181, 203, 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                      ),
                      child: Image.asset(
                        'assets/images/pulgo.png',
                        height: isSmallScreen ? 100 : isMediumScreen ? 130 : 160,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : isMediumScreen ? 16 : 20),
                    
                    // Badge do Pulgo responsivo
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : isMediumScreen ? 16 : 20,
                        vertical: isSmallScreen ? 6 : isMediumScreen ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(126, 218, 132, 1),
                            Color.fromRGBO(87, 181, 203, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 15 : isMediumScreen ? 20 : 25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(126, 218, 132, 0.3),
                            blurRadius: isSmallScreen ? 5 : isMediumScreen ? 8 : 10,
                            offset: Offset(0, isSmallScreen ? 2 : 5),
                          ),
                        ],
                      ),
                      child: Text(
                        '👋 Olá, sou o Pulgo!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 12 : isMediumScreen ? 14 : 16,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                    
                    Text(
                      'Aqui te apresento informações sobre o melhor laboratório da UNIVASF.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: isSmallScreen ? 12 : isMediumScreen ? 14 : 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    
                    // Call to action moderno responsivo
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Esperando o quê? ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: isSmallScreen ? 11 : isMediumScreen ? 12 : 14,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 8 : isMediumScreen ? 10 : 12,
                            vertical: isSmallScreen ? 2 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(126, 218, 132, 0.2),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : isMediumScreen ? 10 : 12),
                          ),
                          child: Text(
                            'DESLIZE PARA CIMA! 🚀',
                            style: TextStyle(
                              color: const Color.fromRGBO(126, 218, 132, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 11 : isMediumScreen ? 12 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Seção LADOPAR com design tech responsivo
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(
                  top: isSmallScreen ? 12 : isMediumScreen ? 16 : 20,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16 : isMediumScreen ? 20 : 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(126, 218, 132, 1),
                      Color.fromRGBO(87, 181, 203, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(126, 218, 132, 0.3),
                      blurRadius: isSmallScreen ? 10 : isMediumScreen ? 15 : 20,
                      offset: Offset(0, isSmallScreen ? 5 : 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header com logo responsivo
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: isSmallScreen ? 8 : 16,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                          ),
                          child: Image.asset(
                            'assets/images/LogoApp.png',
                            height: isSmallScreen ? 25 : isMediumScreen ? 32 : 40,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'LADOPAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 18 : isMediumScreen ? 21 : 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: isSmallScreen ? 0.8 : 1.5,
                              ),
                            ),
                            Text(
                              '@ladopar.nezoon',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isSmallScreen ? 10 : isMediumScreen ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : isMediumScreen ? 20 : 24),
                    
                    // Descrição em container moderno responsivo
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : isMediumScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : isMediumScreen ? 12 : 16),
                        border: Border.all(
                          color: Colors.white.withAlpha(51),
                        ),
                      ),
                      child: Text(
                        'O Laboratório de Doenças Parasitárias (LADOPAR) está localizado dentro da Clínica Veterinária da UNIVASF. '
                        'Sob a orientação do Prof. Dr. Mauricio Horta, o laboratório desenvolve estudos sobre doenças parasitárias de '
                        'importância zoonótica, envolvendo uma ampla diversidade de espécies animais.\n\n'
                        'Da iniciação científica ao doutorado, as atividades do LADOPAR integram ciência, prática clínica e uma '
                        'abordagem interdisciplinar, com foco na promoção da saúde pública e veterinária.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 11 : isMediumScreen ? 12 : 14,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernSocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const ModernSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSmallScreen = false,
  });

  @override
  State<ModernSocialButton> createState() => _ModernSocialButtonState();
}

class _ModernSocialButtonState extends State<ModernSocialButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSmallScreen ? 8 : 16,
              vertical: widget.isSmallScreen ? 6 : 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(widget.isSmallScreen ? 12 : 20),
              border: Border.all(color: Colors.white.withAlpha(76)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(25),
                  blurRadius: widget.isSmallScreen ? 5 : 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.isSmallScreen ? 12 : 16,
                ),
                SizedBox(width: widget.isSmallScreen ? 4 : 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isSmallScreen ? 9 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TechGridPainter extends CustomPainter {
  final double gridSize;
  
  const TechGridPainter({this.gridSize = 30});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(25)
      ..strokeWidth = 0.5;

    // Desenha grade tecnológica com tamanho responsivo
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Adiciona alguns pontos de destaque responsivos
    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(76)
      ..style = PaintingStyle.fill;

    final dotSize = gridSize < 25 ? 1.5 : 2.0;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      dotSize,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      dotSize,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.2),
      dotSize,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}