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
              // Remove the default close button by not setting actions
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
    // Identifica qual jogador está jogando
    final isPlayer1 = widget.currentPlayer == widget.player1Name;
    final currentPlayerName = isPlayer1 ? widget.player1Name : widget.player2Name;
    final currentPlayerPhoto = isPlayer1 ? widget.player1Photo : widget.player2Photo;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF69D1E9), Color(0xFF81DC6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 22,
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
                  currentPlayerName, // Usando o nome real do jogador
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Sua vez de responder!',
                  style: TextStyle(
                    fontSize: 12,
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
    // Map of technical names
    final Map<String, String> technicalNames = {
      'barata': 'Ectoparasitas',
      'minhoca': 'Helmintos',
      'azul': 'Protozoários',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Pergunta sobre:',
            style: TextStyle(
              fontSize: 14,
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
                  padding: const EdgeInsets.all(8),
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
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            technicalNames[widget.animal] ?? widget.animal,
            style: const TextStyle(
              fontSize: 16,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Sombra superior mais clara
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).toInt()), // Reduzido de 0.05
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
          // Sombra inferior mais suave
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()), // Reduzido de 0.2
            offset: const Offset(0, 4),
            blurRadius: 15, // Aumentado para suavizar
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
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
          ),
          child: SingleChildScrollView(
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
          ),
        ),
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
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                // Header sem botão voltar
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                
                // Header do jogador atual
                _buildCurrentPlayerHeader(),
                
                const SizedBox(height: 20),
                
                // Seção do animal
                _buildAnimalSection(),
                
                const SizedBox(height: 20),
                
                // Conteúdo principal em um layout flexível
                if (!isLoading) Expanded(
                  child: Column(
                    children: [
                      _buildQuestionCard(),
                      const SizedBox(height: 8), // Reduzido de 20 para 8
                      // Área de respostas com scroll
                      Expanded(
                        flex: 4, // Aumentado de 3 para 4 para dar mais espaço às alternativas
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: currentQuestion!.opcoes.length,
                          itemBuilder: (context, index) {
                            final op = currentQuestion!.opcoes[index];
                            String texto;
                            String letra;
                            if (op is Map && op.isNotEmpty) {
                              letra = op.keys.first.toUpperCase();
                              texto = op.values.first.toString();
                            } else {
                              letra = String.fromCharCode(65 + index);
                              texto = op.toString();
                            }
                            return _buildAnswerOption(texto, index + 1, letra);
                          },
                        ),
                      ),
                      const SizedBox(height: 8), // Reduzido de 16 para 8
                    ],
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
      ),
    );
  }
}