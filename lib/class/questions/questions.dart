import 'dart:convert';
import 'dart:io';
import 'package:parasitados/class/questions/question.dart';

class Questions {
	int id = 0;
	Map<int,Question> questoes = {};
	static String jsonPath = 'assets/pdf/questions.json';
	int get quantQuestion => questoes.length;

	// Use a factory constructor to handle async initialization
	static Future<Questions> fromJsonFile() async {
		final data = await getAllQuestionsJson(jsonPath);
		final questions = Questions();
		questions.questoes = {
			for (var q in data)
				int.parse(q.keys.first): Question.fromJson(
				int.parse(q.keys.first),
				q[q.keys.first] as Map<String, dynamic>
			)
		};
		// Atualiza o último id
		if (questions.questoes.isNotEmpty) {
			questions.id = questions.questoes.keys.reduce((a, b) => a > b ? a : b);
		} else {
			questions.id = 0;
		}
		return questions;
  	}

	Future<void> addQuestion(Map<String, dynamic> questionData) async {
    final file = File(jsonPath);
    final jsonString = await file.readAsString();
    final List<dynamic> data = json.decode(jsonString);

    // Gera novo id único
    int newId = 1;
    final existingIds = <int>{};
    for (var q in data) {
      final idStr = q.keys.first;
      final idInt = int.tryParse(idStr);
      if (idInt != null) existingIds.add(idInt);
    }
    while (existingIds.contains(newId)) {
      newId++;
    }

    // Adiciona a nova questão mantendo o formato original
    data.add({newId.toString(): questionData});

    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(data), flush: true);
    questoes[newId] = Question.fromJson(newId, questionData);
    id = newId;
  }

	static Future<List<dynamic>> getAllQuestionsJson(String jsonPath) async {
		final file = File(jsonPath);
		final jsonString = await file.readAsString();
		final List<dynamic> data = json.decode(jsonString);
		return data;
	}

	Question? getQuestion(int id){
		return questoes[id];
	}

	Future<void> saveAllToJson() async {
		// Converte todas as questões para o formato [{"id": {...}}, ...]
		final List<Map<String, dynamic>> data = questoes.entries.map((entry) => {
			entry.key.toString(): entry.value.toJson()
		}).toList();
		final encoder = JsonEncoder.withIndent('  ');
		final file = File(jsonPath);
		await file.writeAsString(encoder.convert(data), flush: true);
	}

}