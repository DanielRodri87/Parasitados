import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:parasitados/class/questions/questions.dart';
import '../../class/questions/question.dart';

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

class _QuestionScreenState extends State<QuestionScreen> 
    with TickerProviderStateMixin {
  Question? currentQuestion;
  bool isLoading = true;
  bool? isAnswerCorrect;
  int? selectedAnswer;
  
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadRandomQuestion();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _loadRandomQuestion() async {
    // Carrega todas as questões do JSON
    final questions = await Questions.fromJsonFile('assets/pdf/questions.json');
    final questoesList = questions.questoes.values.toList();
    if (questoesList.isNotEmpty) {
      final random = Random();
		final q = questoesList[random.nextInt(questoesList.length)];

    //   final q = questoesList[Questions.id];
      setState(() {
        currentQuestion = q;
        isLoading = false;
      });
    }
  }

  void _handleAnswer(int answer) async {
    _scaleController.forward().then((_) => _scaleController.reverse());
    
    setState(() {
      selectedAnswer = answer;
      isAnswerCorrect = answer == currentQuestion!.respostaCorreta;
    });

    // Mostra dialog de feedback e retorna resultado
    bool shouldProceed = await _showFeedbackDialog();
    
    // Só procede se o dialog não foi descartado
    if (shouldProceed) {
      widget.onAnswer(isAnswerCorrect!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<bool> _showFeedbackDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Previne fechar ao clicar fora
      builder: (BuildContext context) {
		return PopScope( // Previne o botão de voltar
		  canPop: false,
		  child: ScaleTransition(
			scale: _scaleAnimation,
			child: AlertDialog(
			  backgroundColor: Colors.transparent,
			  elevation: 0,
			  content: Container(
			padding: const EdgeInsets.all(24),
			decoration: BoxDecoration(
			  gradient: LinearGradient(
				colors: isAnswerCorrect!
				? [Colors.green.shade300, Colors.green.shade500]
				: [Colors.red.shade300, Colors.red.shade500],
				begin: Alignment.topLeft,
				end: Alignment.bottomRight,
			  ),
			  borderRadius: BorderRadius.circular(20),
			  boxShadow: [
				BoxShadow(
				  color: Colors.black.withAlpha((0.2 * 255).toInt()),
				  blurRadius: 20,
				  offset: const Offset(0, 10),
				),
			  ],
			),
			child: Column(
			  mainAxisSize: MainAxisSize.min,
			  children: [
				Icon(
				  isAnswerCorrect! ? Icons.check_circle : Icons.cancel,
				  size: 80,
				  color: Colors.white,
				),
				const SizedBox(height: 16),
				Text(
				  isAnswerCorrect! ? 'Parabéns!' : 'Ops!',
				  style: const TextStyle(
				fontSize: 28,
				fontWeight: FontWeight.bold,
				color: Colors.white,
				  ),
				),
				const SizedBox(height: 8),
				Text(
				  isAnswerCorrect! 
				  ? 'Resposta correta! 🎉'
				  : 'Resposta incorreta! 😢',
				  style: const TextStyle(
				fontSize: 18,
				color: Colors.white,
				  ),
				  textAlign: TextAlign.center,
				),
				const SizedBox(height: 24),
				ElevatedButton(
				  onPressed: () => Navigator.of(context).pop(true),
				  style: ElevatedButton.styleFrom(
				backgroundColor: Colors.white,
				foregroundColor: isAnswerCorrect! ? Colors.green : Colors.red,
				padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
				shape: RoundedRectangleBorder(
				  borderRadius: BorderRadius.circular(25),
				),
				  ),
				  child: const Text(
				'Continuar',
			 style: TextStyle(
				  fontSize: 16,
				  fontWeight: FontWeight.bold,
				),
				  ),
				),
			  ],
			),
			  ),
			),
		  ),
		);
      },
    ) ?? false;
  }

  Widget _buildCurrentPlayerHeader() {
    final isPlayer1 = widget.currentPlayer == widget.player1Name;
    final currentPlayerPhoto = isPlayer1 ? widget.player1Photo : widget.player2Photo;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // reduced margin
      padding: const EdgeInsets.all(12), // reduced padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF69D1E9), Color(0xFF81DC6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15), // smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row( // changed to Row layout
        children: [
          CircleAvatar(
            radius: 25, // smaller radius
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22, // smaller radius
              backgroundImage: (currentPlayerPhoto != null && currentPlayerPhoto.isNotEmpty)
                  ? FileImage(File(currentPlayerPhoto))
                  : const AssetImage('assets/images/gatopreto.png') as ImageProvider,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.currentPlayer,
                  style: const TextStyle(
                    fontSize: 16, // smaller font
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Sua vez de responder!',
                  style: TextStyle(
                    fontSize: 12, // smaller font
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // reduced margin
      padding: const EdgeInsets.all(12), // reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row( // changed to Row layout
        children: [
          const Text(
            'Pergunta sobre:',
            style: TextStyle(
              fontSize: 14, // smaller font
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(8), // reduced padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF69D1E9).withAlpha((0.1 * 255).toInt()),
                        const Color(0xFF81DC6E).withAlpha((0.1 * 255).toInt()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/${widget.animal}.png',
                    height: 40, // smaller size
                    width: 40, // smaller size
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            widget.animal,
            style: const TextStyle(
              fontSize: 16, // smaller font
              fontWeight: FontWeight.bold,
              color: Color(0xFF69D1E9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFF69D1E9).withAlpha((0.05 * 255).toInt()),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        currentQuestion!.enunciado,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerOption(String text, int answerIndex, String letter) {
    final isSelected = selectedAnswer == answerIndex;
    final isCorrect = answerIndex == currentQuestion!.respostaCorreta;
    final showResult = selectedAnswer != null;
    
    Color backgroundColor = Colors.white;
    Color borderColor = const Color(0xFF69D1E9).withAlpha((0.3 * 255).toInt());
    Color textColor = Colors.black87;
    Color letterColor = const Color(0xFF69D1E9);

    if (showResult) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green;
        letterColor = Colors.green;
      } else if (isSelected) {
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
        letterColor = Colors.red;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: isSelected ? 8 : 2,
        shadowColor: isSelected ? letterColor.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.1 * 255).toInt()),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: selectedAnswer == null ? () => _handleAnswer(answerIndex) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: letterColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showResult && isCorrect)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                if (showResult && isSelected && !isCorrect)
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FDFF),
              Color(0xFFF0F9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header com botão voltar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF69D1E9),
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Pergunta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF69D1E9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Para centralizar o título
                  ],
                ),
              ),
              
              // Header do jogador atual
              _buildCurrentPlayerHeader(),
              
              const SizedBox(height: 20),
              
              // Seção do animal
              _buildAnimalSection(),
              
              const SizedBox(height: 20),
              
              // Pergunta
              if (!isLoading) _buildQuestionCard(),
              const SizedBox(height: 20),
              // Opções de resposta
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: currentQuestion!.opcoes.length,
                    itemBuilder: (context, index) {
                      // Suporta tanto lista de string quanto lista de mapas {"a": "texto"}
                      final op = currentQuestion!.opcoes[index];
                      String texto;
                      String letra;
                      if (op is Map && op.isNotEmpty) {
                        letra = op.keys.first.toUpperCase();
                        texto = op.values.first.toString();
                      } else {
                        letra = String.fromCharCode(65 + index); // A, B, C, D
                        texto = op.toString();
                      }
                      return _buildAnswerOption(
                        texto,
                        index + 1,
                        letra,
                      );
                    },
                  ),
                ),
              
              // Loading indicator
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF69D1E9)),
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