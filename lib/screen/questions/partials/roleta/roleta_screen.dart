import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/database/ranking_database.dart';
import 'package:parasitados/database/user_database.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/questions/partials/roleta/partials/widget_text_status.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;
import '../../questions_screen.dart';

class RoletaScreen extends StatefulWidget {
  final TypeModeGame modeGame;
  const RoletaScreen({super.key, required this.modeGame});

  @override
  RoletaScreenState createState() => RoletaScreenState();
}

class RoletaScreenState extends State<RoletaScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;

  late DateTime tempoIni;
  late Duration tempoFim;

  String currentPlayer = 'Jogador 1';
  String? selectedAnimal;
  bool isLoading = false;
  List<String> player1Animals = [];
  List<String> player2Animals = [];
  String player1Name = '';
  String player2Name = '';
  String? player1Photo;
  String? player2Photo;
  bool hasAnswered = false;
  bool gameEnded = false;
  String? winner;

  int qtdCorreta = 0;
  int qtdIncorreta = 0;
  int qtdRespondida = 0;

  final List<String> animals = ['barata', 'minhoca', 'azul'];
  late List<String> wheelOptions;
  double finalRotation = 0;

  // Map for gray (unachieved) images
  final Map<String, String> grayAnimalImages = {
    'barata': 'assets/images/barata_cinza.png',
    'minhoca': 'assets/images/minhoca_cinza.png',
    'azul': 'assets/images/azul_cinza.png',
  };

  // Map for colored (achieved) images
  final Map<String, String> coloredAnimalImages = {
    'barata': 'assets/images/barata.png',
    'minhoca': 'assets/images/minhoca.png',
    'azul': 'assets/images/azul.png',
  };

  // Map for animal names in Portuguese
  final Map<String, String> animalNames = {
    'barata': 'Ectoparasitas',
    'minhoca': 'Helmintos',
    'azul': 'Protozoários',
  };

  // Add counters for each animal type for both players
  Map<String, Map<String, int>> playerAnimalCorrectAnswers = {
    'player1': {'barata': 0, 'minhoca': 0, 'azul': 0},
    'player2': {'barata': 0, 'minhoca': 0, 'azul': 0},
  };

  @override
  void initState() {
    super.initState();
    wheelOptions =
        widget.modeGame == TypeModeGame.doisJogador
            ? ['minhoca', 'azul', 'barata', 'passar_vez']
            : ['minhoca', 'azul', 'barata'];
    _loadPlayers();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _confettiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );

    _loadPlayers().then((_) {
      setState(() {
        currentPlayer = player1Name;
      });
    });

    if (widget.modeGame == TypeModeGame.umJogador) {
      tempoIni = DateTime.now();
      player1Animals = List.from(animals);
    }
  }

  Future<void> _loadPlayers() async {
    final database = await _initDatabase();
    final userSharedPref = await UserDatabase.lerUserLocal();

    final List<Map<String, dynamic>> players = await database.query('login');
    if (players.isNotEmpty) {
      setState(() {
        player1Name =
            ((players[0]['nome1'] as String).isEmpty)
                ? userSharedPref!['nome']
                : players[0]['nome1'];
        player2Name = players[0]['nome2'];
        player1Photo = players[0]['foto1'];
        player2Photo = players[0]['foto2'];
      });
    }
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String dbPath = path_package.join(databasesPath, 'login.db');
    return await openDatabase(dbPath);
  }

  Future<void> _checkForWinner() async {
    if (player1Animals.length == 3) {
      setState(() {
        gameEnded = true;
        winner = player1Name;
      });

      _confettiController.repeat();
    } else if (player2Animals.length == 3) {
      setState(() {
        gameEnded = true;
        winner = player2Name;
      });
      _confettiController.repeat();
    }
  }

  Future<void> _checkForLooser() async {
    if (player1Animals.isEmpty) {
      setState(() {
        gameEnded = true;
        winner = player1Name;
      });
      _confettiController.repeat();

      if (widget.modeGame == TypeModeGame.umJogador) {
        tempoFim = DateTime.now().difference(tempoIni);
        double tempoDuracao = tempoFim.inSeconds.floorToDouble();

        if (await RankingDatabase().inserirRanking(
              qtdAcertos: qtdCorreta,
              taxaDeAcerto: qtdCorreta / qtdRespondida,
              tempoRealizado: tempoDuracao,
            ) ==
            0) {
          await RankingDatabase().atualizarRanking(
            qtdAcertos: qtdCorreta,
            taxaDeAcerto: qtdCorreta / qtdRespondida,
            tempoRealizado: tempoDuracao,
          );
        }
      }
    }
  }

  void _spinWheel() {
    if (gameEnded) return;

    setState(() {
      selectedAnimal = null;
      hasAnswered = false;
    });

    // Gera rotação aleatória (múltiplos voltas + posição final)
    final random = Random();
    final extraSpins = 3 + random.nextDouble() * 2; // 3-5 voltas extras
    final finalPosition = random.nextDouble(); // Posição final (0-1)
    final totalRotation = extraSpins + finalPosition;

    _animation = Tween<double>(
      begin: 0,
      end: totalRotation * 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0).whenComplete(() {
      // Calcula onde a seta está apontando (4 seções de 90 graus cada)
      final normalizedRotation = (totalRotation * 2 * pi) % (2 * pi);
      final sectionAngle =
          (2 * pi) /
          wheelOptions.length; // Use wheelOptions.length instead of fixed 4

      // A seta aponta para baixo, então ajustamos para começar do topo
      final adjustedAngle = (normalizedRotation + (pi / 2)) % (2 * pi);
      final sectionIndex = (adjustedAngle / sectionAngle).floor();

      final selectedOption = wheelOptions[sectionIndex % wheelOptions.length];

      setState(() {
        selectedAnimal = selectedOption;
        finalRotation = normalizedRotation;
      });

      // Mostrar popup com o resultado
      _showResultPopup(selectedOption);
    });
  }

  void _showResultPopup(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    result == 'passar_vez' ? 'Passou a vez!' : 'Você tirou:',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (result != 'passar_vez') ...[
                    Image.asset(
                      coloredAnimalImages[result]!,
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      animalNames[result]!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF81DC6E,
                        ).withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.skip_next_rounded,
                        size: 60,
                        color: Color(0xFF81DC6E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Próximo jogador',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (result != 'passar_vez') {
                          _respond();
                        } else {
                          _passTheTurn();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF69D1E9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        result == 'passar_vez' ? 'Continuar' : 'Responder',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _passTheTurn() {
    if (widget.modeGame == TypeModeGame.doisJogador) {
      setState(() {
        currentPlayer =
            currentPlayer == player1Name ? player2Name : player1Name;
        selectedAnimal = null;
      });
    } else {
      setState(() {
        selectedAnimal = null;
      });
    }
  }

  void _respond() async {
    if (selectedAnimal == null || selectedAnimal == 'passar_vez') return;
    late bool isNotCorrect = false;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QuestionScreen(
              animal: selectedAnimal!,
              onAnswer: (bool isCorrect) {
                setState(() {
                  if (isCorrect) {
                    if (widget.modeGame == TypeModeGame.doisJogador) {
                      String currentPlayerKey =
                          currentPlayer == player1Name ? 'player1' : 'player2';
                      List<String> currentPlayerAnimals =
                          currentPlayer == player1Name
                              ? player1Animals
                              : player2Animals;

                      // Increment counter for current player and animal
                      playerAnimalCorrectAnswers[currentPlayerKey]![selectedAnimal!] =
                          (playerAnimalCorrectAnswers[currentPlayerKey]![selectedAnimal!] ??
                              0) +
                          1;

                      // Add achievement only after 3 correct answers
                      if (playerAnimalCorrectAnswers[currentPlayerKey]![selectedAnimal!]! >=
                              3 &&
                          !currentPlayerAnimals.contains(selectedAnimal!)) {
                        if (currentPlayer == player1Name) {
                          player1Animals.add(selectedAnimal!);
                        } else {
                          player2Animals.add(selectedAnimal!);
                        }
                      }
                      _checkForWinner();
                    } else {
                      qtdCorreta++;
                    }
                  } else {
                    if (widget.modeGame == TypeModeGame.umJogador) {
                      isNotCorrect = true;

                      if (player1Animals.contains(selectedAnimal!)) {
                        qtdIncorreta++;
                        player1Animals.remove(selectedAnimal!);
                        // Reset counter for this animal when losing achievement
                        playerAnimalCorrectAnswers['player1']![selectedAnimal!] =
                            0;
                      }
                      _checkForLooser();
                    } else {
                      String currentPlayerKey =
                          currentPlayer == player1Name ? 'player1' : 'player2';
                      // Reset counter on wrong answer in two player mode
                      playerAnimalCorrectAnswers[currentPlayerKey]![selectedAnimal!] =
                          0;
                      currentPlayer =
                          currentPlayer == player1Name
                              ? player2Name
                              : player1Name;
                    }
                  }
                  qtdRespondida++;
                  selectedAnimal = null;
                });
              },
              player1Name: player1Name,
              player2Name: player2Name,
              player1Photo: player1Photo,
              player2Photo: player2Photo,
              currentPlayer: currentPlayer,
            ),
      ),
    );
    if (mounted) {
      if (isNotCorrect) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(child: _buildLosserScreen());
            },
          );
        });
      }
    }
    setState(() {}); // Atualiza a tela da roleta ao voltar
  }

  Widget _buildPlayerInfo(
    String name,
    String? photo,
    List<String> achievedAnimals,
    bool isCurrentPlayer,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        gradient:
            isCurrentPlayer
                ? LinearGradient(
                  colors: [
                    const Color(0xFF69D1E9).withAlpha((0.2 * 255).toInt()),
                    const Color(0xFF81DC6E).withAlpha((0.2 * 255).toInt()),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        borderRadius: BorderRadius.circular(12),
        border:
            isCurrentPlayer
                ? Border.all(color: const Color(0xFF69D1E9), width: 2)
                : null,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    (photo != null && photo.isNotEmpty)
                        ? FileImage(File(photo))
                        : const AssetImage('assets/images/gatopreto.png')
                            as ImageProvider,
              ),
              if (isCurrentPlayer)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF69D1E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isCurrentPlayer ? const Color(0xFF69D1E9) : Colors.black87,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children:
                animals.map((animal) {
                  final bool isAchieved = achievedAnimals.contains(animal);
                  return Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isAchieved
                              ? const Color(
                                0xFF81DC6E,
                              ).withAlpha((0.2 * 255).toInt())
                              : Colors.grey.withAlpha((0.1 * 255).toInt()),
                    ),
                    child: Image.asset(
                      isAchieved
                          ? coloredAnimalImages[animal]!
                          : grayAnimalImages[animal]!,
                      width: 20,
                      height: 20,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(50, (index) {
            final random = Random(index);
            final color =
                [
                  Colors.red,
                  Colors.blue,
                  Colors.yellow,
                  Colors.green,
                  Colors.purple,
                ][random.nextInt(5)];
            final startX =
                random.nextDouble() * MediaQuery.of(context).size.width;
            final fallSpeed = 0.5 + random.nextDouble() * 0.5;
            final currentY =
                -50 +
                (_confettiAnimation.value *
                        (MediaQuery.of(context).size.height + 100)) *
                    fallSpeed;

            return Positioned(
              left: startX,
              top: currentY,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildVictoryScreen() {
    return Container(
      color: Colors.black.withAlpha((0.8 * 255).toInt()),
      child: Stack(
        children: [
          _buildConfetti(),
          Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.shade300,
                    Colors.orange.shade400,
                    Colors.red.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    '🎉 PARABÉNS! 🎉',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$winner venceu!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Conquistou todas as 3 conquistas!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Column(
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            gameEnded = false;
                            winner = null;
                            player1Animals.clear();
                            player2Animals.clear();
                            currentPlayer = player1Name;
                            selectedAnimal = null;
                          });
                          _confettiController.stop();
                          _confettiController.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange.shade400,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Jogar Novamente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange.shade400,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLosserScreen() {
    List<Widget> widgetText = [
      WidgetTextStatus(
        text: [
          'Ei, o que você está fazendo?',
          '😭 😭 😭 😭 😭 ',
          'Era tão fácil...',
        ],
        pathImage: 'assets/pulgo_emotions/pulgo_triste.png',
      ),
      WidgetTextStatus(
        text: [
          'Você vai perder mesmo?',
          '😭 😭 😭 😭 😭 😭',
          'Você não pode errar!!!',
        ],
        pathImage: 'assets/pulgo_emotions/pulgo_nao_sabe.png',
      ),
      WidgetTextStatus(
        text: [
          'AAAAAAAAAAAAAAAAAAAAAAAA',
          '😡 😡 😡 😡 😡 😡',
          'NÃO! NÃO! NÃO!',
          'EU TENTEI CONFIAR!',
          'ADEUS!',
        ],
        pathImage: 'assets/pulgo_emotions/pulgo_puto.png',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffCD1A1A), Color(0xff670D0D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  if (mounted) Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 70,
              bottom: 70,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetText[qtdIncorreta - 1],
                const SizedBox(height: 30),
                if (qtdIncorreta == 3)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.restorablePopAndPushNamed(
                        context,
                        Routes.rankingScreen,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Ranking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Players Card - Centralizado
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'JOGADORES',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children:
                                  widget.modeGame == TypeModeGame.doisJogador
                                      ? [
                                        Expanded(
                                          child: _buildPlayerInfo(
                                            player1Name,
                                            player1Photo,
                                            player1Animals,
                                            currentPlayer == player1Name,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Image.asset(
                                            'assets/images/vs.png',
                                            height: 40,
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildPlayerInfo(
                                            player2Name,
                                            player2Photo,
                                            player2Animals,
                                            currentPlayer == player2Name,
                                          ),
                                        ),
                                      ]
                                      : [
                                        Expanded(
                                          child: _buildPlayerInfo(
                                            player1Name,
                                            player1Photo,
                                            player1Animals,
                                            true,
                                          ),
                                        ),
                                      ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Game Card - Expandido e moderno
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Padrão de fundo sutil
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue.withAlpha(
                                        (0.02 * 255).toInt(),
                                      ),
                                      Colors.green.withAlpha(
                                        (0.02 * 255).toInt(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Círculos decorativos
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xFF69D1E9,
                                  ).withAlpha((0.1 * 255).toInt()),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -30,
                              left: -30,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xFF81DC6E,
                                  ).withAlpha((0.1 * 255).toInt()),
                                ),
                              ),
                            ),
                            // Conteúdo principal
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  // Indicador da vez do jogador
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF69D1E9),
                                          Color(0xFF81DC6E),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF69D1E9,
                                          ).withAlpha((0.3 * 255).toInt()),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'VEZ DE: ${currentPlayer.toUpperCase()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Roleta (aumentada e centralizada)
                                  Expanded(
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: _spinWheel,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  (0.15 * 255).toInt(),
                                                ),
                                                blurRadius: 20,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: RotationTransition(
                                            turns: _animation,
                                            child: Image.asset(
                                              'assets/images/roleta.png',
                                              width: 320,
                                              height: 320,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Área de loading/status
                                  SizedBox(
                                    height: 80,
                                    child: Center(
                                      child:
                                          isLoading
                                              ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/carregando.png',
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    'Verificando resposta...',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withAlpha(
                                                    (0.1 * 255).toInt(),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  '🎯 Toque na roleta para girar!',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                    ),
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
          ),
          if (gameEnded) ...[
            if (widget.modeGame == TypeModeGame.doisJogador)
              _buildVictoryScreen(),
          ],
        ],
      ),
    );
  }
}
