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
            // Cabeçalho com carrapato e botões
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF010D47), Color(0xFF07051A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SocialButton(text: 'Instagram'),
                      SocialButton(text: 'E-mail'),
                      SocialButton(text: 'GitHub'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/carraputo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'BEM-VINDO AO LADOPAR!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Seção do Pulgo
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/pulgo.png',
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    color: Colors.black,
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

            // Seção de informações do LADOPAR
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
                    'assets/images/logo.png', // Substituir pelo logo correto
                    height: 80,
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
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
