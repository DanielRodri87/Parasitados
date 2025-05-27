import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: const Center(
        child: Text(
          'Aqui vem a lógica do jogo, difícil demais de fazer',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}