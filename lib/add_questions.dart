import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.transparent,
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(context).padding.top + 40, 16.0, 16.0), // reduced top padding
              child: Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/LogoApp.png',
                    height: 230, // back to original size
                  ),
                  const SizedBox(height: 10), // reduced spacing

                  // Card do enunciado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Digite o enunciado aqui...',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // reduced spacing

                  // Opções
                  OptionTile(
                    optionLetter: 'A',
                    hint: 'Digite a letra A',
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  OptionTile(
                    optionLetter: 'B',
                    hint: 'Digite a letra B',
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  OptionTile(
                    optionLetter: 'C',
                    hint: 'Digite a letra C',
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  OptionTile(
                    optionLetter: 'D',
                    hint: 'Digite a letra D',
                    value: 4,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20), // adjusted final spacing
                  SizedBox(
                    width: 200, // reduced from double.infinity
                    height: 45, // reduced from 50
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementar lógica de cadastro
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DB8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para as opções
class OptionTile extends StatelessWidget {
  final String optionLetter;
  final String hint;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;

  const OptionTile({
    super.key,
    required this.optionLetter,
    required this.hint,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Círculo com a letra
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF69D1E9),
                  Color(0xFF75D6AB),
                  Color(0xFF7BD98D),
                  Color(0xFF81DC6E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              optionLetter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // Campo de texto
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),

          // Radio button
          Radio<int>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
