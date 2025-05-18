import 'package:flutter/material.dart';

class LoadingGamePage extends StatelessWidget {
  const LoadingGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
                Color(0xFF69D1E9),
                Color(0xFF75D6AB),
                Color(0xFF7BD98D),
                Color(0xFF81DC6E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Image.asset(
              'assets/images/LogoApp.png',
              height: 260,
            ),
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                child: SimplifiedContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimplifiedContainer extends StatelessWidget {
  const SimplifiedContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
      child: Container(
        height: 700,
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fundo com imagem
            Image.asset(
              'assets/images/back_login.png',
              fit: BoxFit.fitHeight,
            ),

            // Conteúdo simplificado
            SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Área reservada para seu conteúdo personalizado
                  const SizedBox(height: 400), // Espaço para adicionar seus widgets
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}