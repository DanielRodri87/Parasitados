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

	Future<int> addQuestion(Map<String, dynamic> questionData) async {
		final file = File(jsonPath);
		final jsonString = await file.readAsString();
		final List<dynamic> data = json.decode(jsonString);

		int newId = quantQuestion + 1;

		data.add({newId.toString(): questionData});

		final encoder = JsonEncoder.withIndent('  ');
		await file.writeAsString(encoder.convert(data), flush: true);
		questoes[newId] = Question.fromJson(newId, questionData);
		id = newId;

		return newId;
	}

	Future<bool> delQuestion(int id) async {
		try {
			final file = File(jsonPath);
			final jsonString = await file.readAsString();
			final List<dynamic> data = json.decode(jsonString);

			// Remove a questão do arquivo JSON
			data.removeWhere((element) => element.keys.first == id.toString());

			final encoder = JsonEncoder.withIndent('  ');
			await file.writeAsString(encoder.convert(data), flush: true);

			// Remove do mapa em memória
			questoes.remove(id);
			return true;
		} catch (e) {
			return false;
		}
	}

	Future<bool> updateQuestion(int id, Question question) async {
		try {
			final file = File(jsonPath);
			final jsonString = await file.readAsString();
			final List<dynamic> data = json.decode(jsonString);

			// Atualiza a questão no arquivo JSON
			for (int i = 0; i < data.length; i++) {
				if (data[i].keys.first == id.toString()) {
					data[i] = {id.toString(): question.toJson()};
					break;
				}
			}

			final encoder = JsonEncoder.withIndent('  ');
			await file.writeAsString(encoder.convert(data), flush: true);

			// Atualiza no mapa em memória
			questoes[id] = question;
			return true;
		} catch (e) {
			return false;
		}
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