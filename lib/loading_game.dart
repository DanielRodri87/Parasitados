import 'dart:async';
import 'dart:io'; // Importação necessária para usar File
import 'package:flutter/material.dart';
import 'login_database.dart';
import 'home.dart';

class LoadingGamePage extends StatefulWidget {
  const LoadingGamePage({super.key});

  @override
  State<LoadingGamePage> createState() => _LoadingGamePageState();
}

class _LoadingGamePageState extends State<LoadingGamePage> {
  String nome1 = '';
  String nome2 = '';
  String? foto1;
  String? foto2;

  String carregandoTexto = 'Carregando';
  int pontoCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    carregarDados();
    iniciarAnimacaoTexto();
    iniciarTemporizador();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void iniciarAnimacaoTexto() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        pontoCount = (pontoCount + 1) % 4;
        carregandoTexto = 'Carregando${'.' * pontoCount}';
      });
    });
  }

  void iniciarTemporizador() {
    Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  Future<void> carregarDados() async {
    try {
      final db = await LoginDatabase().database;
      final resultado = await db.query('login', limit: 1);

      if (!mounted) return;

      if (resultado.isNotEmpty) {
        final dados = resultado.first;
        setState(() {
          nome1 = dados['nome1'] as String? ?? 'Jogador 1';
          nome2 = dados['nome2'] as String? ?? 'Jogador 2';
          foto1 = dados['foto1'] as String?;
          foto2 = dados['foto2'] as String?;
        });
      } else {
        setState(() {
          nome1 = 'Jogador 1';
          nome2 = 'Jogador 2';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao carregar os dados: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

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
              height: 200,
            ),
            const Expanded(
              child: PlayerInfoContainer(),
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
  String? foto1;
  String? foto2;

  String carregandoTexto = 'Carregando';
  int pontoCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    carregarDados();
    iniciarAnimacaoTexto();
    iniciarTemporizador();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void iniciarAnimacaoTexto() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        pontoCount = (pontoCount + 1) % 4;
        carregandoTexto = 'Carregando${'.' * pontoCount}';
      });
    });
  }

  void iniciarTemporizador() {
    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  Future<void> carregarDados() async {
    try {
      final db = await LoginDatabase().database;
      final resultado = await db.query('login', limit: 1);

      if (!mounted) return;

      if (resultado.isNotEmpty) {
        final dados = resultado.first;
        setState(() {
          nome1 = dados['nome1'] as String? ?? 'Jogador 1';
          nome2 = dados['nome2'] as String? ?? 'Jogador 2';
          foto1 = dados['foto1'] as String?;
          foto2 = dados['foto2'] as String?;
        });
      } else {
        setState(() {
          nome1 = 'Jogador 1';
          nome2 = 'Jogador 2';
        });
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao carregar os dados: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/back_login.png',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 80), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  playerCard(nome1, foto1),
                  Image.asset(
                    'assets/images/fite.png',
                    width: 90,
                  ),
                  playerCard(nome2, foto2),
                ],
              ),
              const Spacer(),
              Text(
                carregandoTexto,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Os parasitas são tipo aqueles amigos folgados: entram na sua casa, comem sua comida e nunca vão embora.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget playerCard(String nome, String? foto) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: (foto != null && foto.isNotEmpty)
              ? FileImage(File(foto)) // Use FileImage para caminhos de arquivo
              : const AssetImage('assets/images/gatopreto.png') as ImageProvider,
        ),
        const SizedBox(height: 16),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}