import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(const MaterialApp(
    home: ViewQuestionsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class ViewQuestionsScreen extends StatefulWidget {
  const ViewQuestionsScreen({super.key});

  @override
  State<ViewQuestionsScreen> createState() => _ViewQuestionsScreenState();
}

class _ViewQuestionsScreenState extends State<ViewQuestionsScreen> {
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final db = await LoginDatabase().database;
    final List<Map<String, dynamic>> result =
        await db.query('questions', orderBy: 'id DESC');
    setState(() {
      questions = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perguntas Cadastradas'),
        backgroundColor: const Color(0xFF00DB8F),
      ),
      body: questions.isEmpty
          ? const Center(child: Text('Nenhuma pergunta cadastrada'))
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${q['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Enunciado: ${q['enunciado']}'),
                        const SizedBox(height: 4),
                        Text('A: ${q['opcao_a']}'),
                        Text('B: ${q['opcao_b']}'),
                        Text('C: ${q['opcao_c']}'),
                        Text('D: ${q['opcao_d']}'),
                        const SizedBox(height: 4),
                        Text(
                          'Resposta correta: ${_mapResposta(q['resposta_correta'])}',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _mapResposta(int resposta) {
    switch (resposta) {
      case 1:
        return 'A';
      case 2:
        return 'B';
      case 3:
        return 'C';
      case 4:
        return 'D';
      default:
        return 'Desconhecida';
    }
  }
}
