import 'dart:convert';
import 'dart:io';

import 'package:parasitados/class/questions/question.dart';

class Questions {
	static int id = 0;
	Map<int,Question> questoes = {};

	Questions();

	// Use a factory constructor to handle async initialization
	static Future<Questions> fromJsonFile(String jsonPath) async {
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
			Questions.id = questions.questoes.keys.reduce((a, b) => a > b ? a : b);
		} else {
			Questions.id = 0;
		}
		return questions;
	}

	int getQuantQuestion(){
		Questions.id = questoes.keys.reduce((a, b) => a > b ? a : b);
		return Questions.id;
	}

	// Renomeia o método estático para evitar conflito
	Future<void> addQuestion(String jsonPath, Map<String, dynamic> questionData) async {
		final file = File(jsonPath);
		final jsonString = await file.readAsString();
		final List<dynamic> data = json.decode(jsonString);
		Questions.id++;

		// Gera o novo id
		final newId = (Questions.id).toString();

		// Adiciona a nova questão mantendo o formato original
		data.add({newId: questionData});

		// Salva de volta mantendo o formato (lista de mapas)
		final encoder = JsonEncoder.withIndent('  ');
		await file.writeAsString(encoder.convert(data), flush: true);

		// Incrementa o id apenas após salvar com sucesso

		// Adiciona também na própria instância da classe
		questoes[int.parse(newId)] = Question.fromJson(int.parse(newId), questionData);
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

	Future<void> saveAllToJson(String jsonPath) async {
		// Converte todas as questões para o formato [{"id": {...}}, ...]
		final List<Map<String, dynamic>> data = questoes.entries.map((entry) => {
			entry.key.toString(): entry.value.toJson()
		}).toList();
		final encoder = JsonEncoder.withIndent('  ');
		final file = File(jsonPath);
		await file.writeAsString(encoder.convert(data), flush: true);
	}
}