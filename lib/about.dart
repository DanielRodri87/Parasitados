import 'package:flutter/material.dart';

class LadoparScreen extends StatelessWidget {
  const LadoparScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20), // Increased vertical padding
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF010D47), Color(0xFF07051A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30), // Increased spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SocialButton(text: 'Instagram'),
                      SocialButton(text: 'E-mail'),
                      SocialButton(text: 'GitHub'),
                    ],
                  ),
                  const SizedBox(height: 60), // Increased spacing here
                  Stack(
                    clipBehavior: Clip.none, // Add this to prevent clipping
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80), // Increased from 40 to 60
                        child: const Text(
                          'BEM-VINDO\n                  AO LADOPAR!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Positioned(
                        top: -8, // Adjusted to move up more
                        right: 20,
                        child: Image.asset(
                          'assets/images/carraputo.png',
                          height: 140,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.image, color: Colors.white, size: 60),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/pulgo.png',  // Updated path
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.pets, color: Colors.grey, size: 100),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Olá, sou o Pulgo!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aqui te apresento informações sobre o melhor laboratório da UNIVASF.\n\n'
                    'Esperando o quê?\nARRASTA PARA CIMA!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF010D47), Color(0xFF07051A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'LADOPAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '@ladopar.nezoon',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logo_ladopar.png',  // Updated path
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.science, color: Colors.white, size: 40),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'O Laboratório de Doenças Parasitárias (LADOPAR) está localizado dentro da Clínica Veterinária da UNIVASF. '
                    'Sob a orientação do Prof. Dr. Mauricio Horta, o laboratório desenvolve estudos sobre doenças parasitárias de '
                    'importância zoonótica, envolvendo uma ampla diversidade de espécies animais. Da iniciação científica ao doutorado, '
                    'as atividades do LADOPAR integram ciência, prática clínica e uma abordagem interdisciplinar, com foco na promoção '
                    'da saúde pública e veterinária.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  const SocialButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: () {
        // Aqui você pode adicionar as ações específicas para cada botão
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$text em desenvolvimento'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}