import 'package:flutter/material.dart';
import 'login_database.dart';

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
                child: PlayerInfoContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerInfoContainer extends StatefulWidget {
  const PlayerInfoContainer({super.key});

  @override
  State<PlayerInfoContainer> createState() => _PlayerInfoContainerState();
}

class _PlayerInfoContainerState extends State<PlayerInfoContainer> {
  String nome1 = '';
  String nome2 = '';

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final db = await LoginDatabase().database;
      final resultado = await db.query('login', limit: 1);

      if (resultado.isNotEmpty) {
        final dados = resultado.first;
        setState(() {
          nome1 = dados['nome1'] as String? ?? 'Jogador 1';
          nome2 = dados['nome2'] as String? ?? 'Jogador 2';
        });
      } else {
        setState(() {
          nome1 = 'Jogador 1';
          nome2 = 'Jogador 2';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Jogador 1: $nome1',
              style: const TextStyle(fontSize: 22, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              'Jogador 2: $nome2',
              style: const TextStyle(fontSize: 22, color: Colors.black),
            ),
            const SizedBox(height: 400),
          ],
        ),
      ),
    );
  }
}