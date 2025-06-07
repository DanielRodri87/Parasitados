import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;

class QuestionScreen extends StatefulWidget {
  final String animal;
  final Function(bool) onAnswer;
  final String player1Name;
  final String player2Name;
  final String? player1Photo;
  final String? player2Photo;
  final String currentPlayer;

  const QuestionScreen({
    super.key, 
    required this.animal,
    required this.onAnswer,
    required this.player1Name,
    required this.player2Name,
    required this.player1Photo,
    required this.player2Photo,
    required this.currentPlayer,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Widget _buildPlayerInfo(String name, String? photo) {
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
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: name == widget.currentPlayer ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPlayerInfo(widget.player1Name, widget.player1Photo),
                        Image.asset(
                          'assets/images/vs.png',
                          height: 80,  // Increased from 50 to 80
                        ),
                        _buildPlayerInfo(widget.player2Name, widget.player2Photo),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Header
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Reduced padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3, // Give more space to text
                          child: Text(
                            "Pergunta sobre: ${widget.animal}",
                            style: const TextStyle(
                              fontSize: 18, // Slightly reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/${widget.animal}.png',
                          height: 35, // Slightly reduced size
                          width: 35,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Question Card
                Expanded(
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Aqui vai a pergunta sobre o parasita selecionado?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          _buildAnswerButton("Resposta A", true),
                          const SizedBox(height: 16),
                          _buildAnswerButton("Resposta B", false),
                          const SizedBox(height: 16),
                          _buildAnswerButton("Resposta C", false),
                          const SizedBox(height: 16),
                          _buildAnswerButton("Resposta D", false),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, bool isCorrect) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF69D1E9),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: const Color(0xFF69D1E9).withOpacity(0.5)),
        ),
      ),
      onPressed: () {
        widget.onAnswer(isCorrect);
        Navigator.pop(context);
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
