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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String currentPlayer = 'Jogador 1';
  String? selectedAnimal;
  bool isLoading = false;
  List<String> player1Animals = [];
  List<String> player2Animals = [];
  String player1Name = '';
  String player2Name = '';
  String? player1Photo;
  String? player2Photo;

  final List<String> animals = ['barata', 'minhoca', 'azul'];
  
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

  void _spinWheel() {
    setState(() {
      selectedAnimal = null;
    });
    _controller.forward(from: 0).whenComplete(() {
      final random = Random();
      final animal = animals[random.nextInt(animals.length)];
      setState(() {
        selectedAnimal = animal;
        if (currentPlayer == 'Jogador 1') {
          if (!player1Animals.contains(animal)) {
            player1Animals.add(animal);
          }
        } else {
          if (!player2Animals.contains(animal)) {
            player2Animals.add(animal);
          }
        }
      });
    });
  }

  void _respond() {
    setState(() {
      isLoading = true;
    });
    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        currentPlayer = currentPlayer == 'Jogador 1' ? 'Jogador 2' : 'Jogador 1';
      });
    });
  }

  Widget _buildPlayerInfo(String name, String? photo, List<String> achievedAnimals) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,  // Increased from 30
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlayer1Turn = currentPlayer == 'Jogador 1';
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
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
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _spinWheel,
                            child: RotationTransition(
                              turns: _animation,
                              child: Image.asset(
                                'assets/images/roleta.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (selectedAnimal != null)
                            Column(
                              children: [
                                Text(
                                  'Animal sorteado: $selectedAnimal',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Image.asset(
                                  grayAnimalImages[selectedAnimal!]!,
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _respond,
                            child: const Text('Responder'),
                          ),
                          if (isLoading)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Image.asset(
                                'assets/images/carregando.png',
                                width: 50,
                                height: 50,
                              ),
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
    );
  }
}
