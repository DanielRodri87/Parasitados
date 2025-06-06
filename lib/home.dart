import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;
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

  final List<String> animals = ['barata', 'minhoca', 'azul'];
  final List<String> wheelOptions = ['minhoca', 'azul', 'barata', 'passar_vez'];
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
    'barata': 'Barata',
    'minhoca': 'Minhoca',
    'azul': 'Azul',
  };

  @override
  void initState() {
    super.initState();
    _loadPlayers();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _confettiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  Future<void> _loadPlayers() async {
    final database = await _initDatabase();
    final List<Map<String, dynamic>> players = await database.query('login');
    if (players.isNotEmpty) {
      setState(() {
        player1Name = players[0]['nome1'];
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

  void _checkForWinner() {
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
      end: totalRotation * 2 * pi
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _controller.forward(from: 0).whenComplete(() {
      // Calcula onde a seta está apontando (4 seções de 90 graus cada)
      final normalizedRotation = (totalRotation * 2 * pi) % (2 * pi);
      final sectionAngle = (2 * pi) / 4; // 4 opções na roleta
      
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.blue.shade400,
                  Colors.teal.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          result == 'passar_vez' ? 'Ops!' : 'Você tirou:',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (result != 'passar_vez') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            coloredAnimalImages[result]!,
                            width: 80,
                            height: 80,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          animalNames[result]!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.skip_next,
                            size: 60,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Passar a vez',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (result != 'passar_vez') {
                            _respond();
                          } else {
                            _passTheTurn();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          result == 'passar_vez' ? 'Passar a vez' : 'Responder',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (result == 'passar_vez') {
                        _passTheTurn();
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _passTheTurn() {
    setState(() {
      currentPlayer = currentPlayer == 'Jogador 1' ? 'Jogador 2' : 'Jogador 1';
      selectedAnimal = null;
    });
  }

  void _respond() {
    setState(() {
      isLoading = true;
    });
    
    // Simulate loading and response validation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        hasAnswered = true;
        
        // Simula que o usuário sempre acerta (retorna true)
        // Aqui você integraria com a tela de resposta real
        bool userAnsweredCorrectly = true;
        
        if (userAnsweredCorrectly && selectedAnimal != null) {
          // Adiciona a conquista apenas se acertou
          if (currentPlayer == 'Jogador 1') {
            if (!player1Animals.contains(selectedAnimal!)) {
              player1Animals.add(selectedAnimal!);
            }
          } else {
            if (!player2Animals.contains(selectedAnimal!)) {
              player2Animals.add(selectedAnimal!);
            }
          }
          
          // Verifica se alguém ganhou
          _checkForWinner();
        } else {
          // Se errou, muda o jogador
          currentPlayer = currentPlayer == 'Jogador 1' ? 'Jogador 2' : 'Jogador 1';
        }
        
        selectedAnimal = null; // Reset para próxima rodada
      });
    });
  }

  Widget _buildPlayerInfo(String name, String? photo, List<String> achievedAnimals) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: (photo != null && photo.isNotEmpty)
              ? FileImage(File(photo))
              : const AssetImage('assets/images/gatopreto.png') as ImageProvider,
        ),
        const SizedBox(height: 8),
        Text(name),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: animals.map((animal) {
            final bool isAchieved = achievedAnimals.contains(animal);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                isAchieved ? coloredAnimalImages[animal]! : grayAnimalImages[animal]!,
                width: 30,
                height: 30,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(50, (index) {
            final random = Random(index);
            final color = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.purple][random.nextInt(5)];
            final startX = random.nextDouble() * MediaQuery.of(context).size.width;
            final fallSpeed = 0.5 + random.nextDouble() * 0.5;
            final currentY = -50 + (_confettiAnimation.value * (MediaQuery.of(context).size.height + 100)) * fallSpeed;
            
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
      color: Colors.black.withOpacity(0.8),
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
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.white,
                  ),
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
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameEnded = false;
                        winner = null;
                        player1Animals.clear();
                        player2Animals.clear();
                        currentPlayer = 'Jogador 1';
                        selectedAnimal = null;
                      });
                      _confettiController.stop();
                      _confettiController.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                ],
              ),
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
                    // Players Card
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Vez de: $currentPlayer',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildPlayerInfo(player1Name, player1Photo, player1Animals),
                                  _buildPlayerInfo(player2Name, player2Photo, player2Animals),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Game Card
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Stack para sobrepor a seta à roleta
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Roleta (aumentada)
                                      GestureDetector(
                                        onTap: _spinWheel,
                                        child: RotationTransition(
                                          turns: _animation,
                                          child: Image.asset(
                                            'assets/images/roleta.png',
                                            width: 280,
                                            height: 280,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      // Seta apontando para baixo (fixa)
                                      Positioned(
                                        bottom: 20,
                                        child: Container(
                                          width: 0,
                                          height: 0,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(width: 15, color: Colors.transparent),
                                              right: BorderSide(width: 15, color: Colors.transparent),
                                              bottom: BorderSide(width: 25, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (isLoading)
                                  const Column(
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Verificando resposta...',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (gameEnded) _buildVictoryScreen(),
        ],
      ),
    );
  }
}