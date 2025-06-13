import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import '../../database/database.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  int? selectedOption;

  final TextEditingController enunciadoController = TextEditingController();
  final TextEditingController opcaoAController = TextEditingController();
  final TextEditingController opcaoBController = TextEditingController();
  final TextEditingController opcaoCController = TextEditingController();
  final TextEditingController opcaoDController = TextEditingController();

  final LoginDatabase dbHelper = LoginDatabase();

  Future<void> _cadastrarQuestao() async {
    try {
      final enunciado = enunciadoController.text.trim();
      final opcaoA = opcaoAController.text.trim();
      final opcaoB = opcaoBController.text.trim();
      final opcaoC = opcaoCController.text.trim();
      final opcaoD = opcaoDController.text.trim();

      if (enunciado.isEmpty ||
          opcaoA.isEmpty ||
          opcaoB.isEmpty ||
          opcaoC.isEmpty ||
          opcaoD.isEmpty ||
          selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos e selecione a correta')),
        );
        return;
      }

      // Carrega as questões existentes do JSON
      final jsonPath = 'assets/pdf/questions.json';
      final questions = await Questions.fromJsonFile(jsonPath);
      // Gera novo id
      // Cria a nova questão
      // Adiciona ao JSON
      await questions.addQuestion(
        jsonPath,
        {
          'pergunta': enunciado,
          'resposta': String.fromCharCode(96 + selectedOption!), // 1->a, 2->b, etc
          'alternativas': [
            {"a": opcaoA},
            {"b": opcaoB},
            {"c": opcaoC},
            {"d": opcaoD},
          ]
        },
      );
		if(mounted){
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Questão cadastrada com sucesso no JSON')),
			);
		}
      // Limpar campos
      enunciadoController.clear();
      opcaoAController.clear();
      opcaoBController.clear();
      opcaoCController.clear();
      opcaoDController.clear();
      setState(() {
        selectedOption = null;
      });

    } catch (e) {
		if(mounted){
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text('Erro ao cadastrar questão: $e')),
			);
		}
    }
  }

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
              padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(context).padding.top + 40, 16.0, 16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/LogoApp.png', height: 230),
                  const SizedBox(height: 10),

                  // Enunciado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: enunciadoController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Digite o enunciado aqui...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Opções
                  OptionTile(
                    controller: opcaoAController,
                    optionLetter: 'A',
                    hint: 'Digite a alternativa A',
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
                    controller: opcaoBController,
                    optionLetter: 'B',
                    hint: 'Digite a alternativa B',
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
                    controller: opcaoCController,
                    optionLetter: 'C',
                    hint: 'Digite a alternativa C',
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
                    controller: opcaoDController,
                    optionLetter: 'D',
                    hint: 'Digite a alternativa D',
                    value: 4,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Botão Cadastrar
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _cadastrarQuestao,
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

// 🔥 Widget das opções com TextField + RadioButton
class OptionTile extends StatelessWidget {
  final TextEditingController controller;
  final String optionLetter;
  final String hint;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;

  const OptionTile({
    super.key,
    required this.controller,
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
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
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
