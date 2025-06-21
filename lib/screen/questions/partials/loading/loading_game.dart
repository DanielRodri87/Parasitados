import 'dart:async';
import 'dart:io'; // Importação necessária para usar File
import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/database/database.dart';
import 'package:parasitados/database/user_database.dart';
import 'package:parasitados/routes/routes.dart';

class LoadingGamePage extends StatefulWidget {
	final TypeModeGame tipoModeGame;

  const LoadingGamePage({
	super.key,
	required this.tipoModeGame
	});

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
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        pontoCount = (pontoCount + 1) % 4;
        carregandoTexto = 'Carregando${'.' * pontoCount}';
      });
    });
  }

  void iniciarTemporizador() {
    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      	if (widget.tipoModeGame == TypeModeGame.umJogador) {
			Navigator.pushReplacementNamed(context, Routes.questionScreenUmJogador);
		}else{
			Navigator.pushReplacementNamed(context, Routes.questionScreenDoisJogador);
		}
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
            Expanded(
              child: PlayerInfoContainer(
                tipoModeGame: widget.tipoModeGame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerInfoContainer extends StatefulWidget {
	final TypeModeGame tipoModeGame;
  const PlayerInfoContainer({
	super.key,
	required this.tipoModeGame
	});

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

  final List<String> frases = [
    'Os parasitas são tipo aqueles amigos folgados: entram na sua casa, comem sua comida e nunca vão embora.',
    'Bactéria é tipo visita que você nem chamou e ainda deixa a casa toda bagunçada.',
    'Fungo é aquele colega de quarto que cresce no canto do banheiro e se recusa a sair.',
    'Vírus é como ex tóxico: aparece do nada, se instala sem permissão e deixa você mal depois.',
    'Piolho é tipo criança em festinha: vem em bando, gruda e só vai embora na base do grito (ou shampoo).',
    'Tênia é aquele hóspede que come tudo, mas nunca engorda. Quem emagrece é você!',
    'Ameba é tipo estagiário perdido: tá lá, ocupando espaço e ninguém sabe muito bem o que tá fazendo.',
    'Carrapato é como cobrança de boleto: gruda e suga até o último centavo de energia.',
    'Lombriga é o pet que você nunca pediu, mas que mora dentro de você.',
    'Protozoário é aquele colega invisível que sempre atrasa o rolê com uma diarreia surpresa.',
    'Pulga é tipo fofoqueiro: vive pulando de um canto pro outro e incomoda todo mundo.',
  ];
  int fraseAtual = 0;
  Timer? timerFrases;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    carregarDados();
    iniciarAnimacaoTexto();
    iniciarTemporizador();
    iniciarRotacaoFrases();
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
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
		if (widget.tipoModeGame == TypeModeGame.umJogador) {
			Navigator.pushReplacementNamed(context, Routes.questionScreenUmJogador);
		}else{
			Navigator.pushReplacementNamed(context, Routes.questionScreenDoisJogador);
		}
    });
  }

  void iniciarRotacaoFrases() {
    timerFrases = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        fraseAtual = _random.nextInt(frases.length);
      });
    });
  }

  Future<void> carregarDados() async {
    try {
      final db = await LoginDatabase().database;
      final resultado = await db.query('login', limit: 1);
      final dadosShared = await UserDatabase.lerUserLocal();

      if (!mounted) return;

      if (resultado.isNotEmpty) {
        final dados = resultado.first;
        setState(() {
		  nome1 = (dados['nome1'] != null && (dados['nome1'] as String).isNotEmpty)
			  ? dados['nome1']
			  : (dadosShared?['nome'] != null && (dadosShared?['nome'] as String).isNotEmpty)
				  ? dadosShared!['nome']
				  : 'Jogador 1';
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
  void dispose() {
    timer?.cancel();
    timerFrases?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
	return Container(
		width: double.infinity,
		// height: double.infinity,
		decoration: BoxDecoration(
			image: DecorationImage(
				image: AssetImage('assets/images/back_login.png'),
				fit: BoxFit.fill,
			)
		),
		padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
		child: Column(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				if (widget.tipoModeGame == TypeModeGame.doisJogador)
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
					)
				else
					Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							playerCard(nome1, foto1),
						],
					),
				Column(
					spacing: 20,
					children: [
						Text(
							carregandoTexto,
							style: const TextStyle(
								fontSize: 24,
								fontWeight: FontWeight.bold,
							),
						),
						Text(
							frases[fraseAtual],
							textAlign: TextAlign.center,
							style: const TextStyle(
							fontSize: 16,
							color: Colors.black54,
							),
						),
					],
				)
				
			],
		),
	);
  }
}