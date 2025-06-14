import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/provider/question_database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuestionsProvider extends ChangeNotifier {
	Questions _questions = Questions();
	Questions get questions => _questions;
	bool _hasSynced = false;

	Future<void> loadFromJson(String jsonPath) async {
		// Tenta carregar do cache local primeiro
		final prefs = await SharedPreferences.getInstance();
		final cached = prefs.getString('questions_cache');
		if (cached != null) {
			final List<dynamic> data = json.decode(cached);
			_questions.questoes = {
				for (var q in data)
					int.parse(q.keys.first): Question.fromJson(
						int.parse(q.keys.first),
						q[q.keys.first] as Map<String, dynamic>
					)
			};
			notifyListeners();
			return;
		}
		// Se não houver cache, carrega do arquivo
		_questions = await Questions.fromJsonFile(jsonPath);
		// Salva no cache
		await prefs.setString('questions_cache', json.encode(_questions.questoes.entries.map((e) => {e.key.toString(): e.value.toJson()}).toList()));
		notifyListeners();
	}

	Future<void> addQuestion(String jsonPath, Map<String, dynamic> questionData) async {
		await _questions.addQuestion(jsonPath, questionData);
		// Atualiza o cache
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString('questions_cache', json.encode(_questions.questoes.entries.map((e) => {e.key.toString(): e.value.toJson()}).toList()));
		notifyListeners();
	}

	Question? getQuestion(int id) {
		return _questions.getQuestion(id);
	}

	Future<bool> _loadFromCache() async {
		final prefs = await SharedPreferences.getInstance();
		final cached = prefs.getString('questions_cache');
		if (cached != null) {
			final List<dynamic> data = json.decode(cached);
			_questions.questoes = {
				for (var q in data)
					int.parse(q.keys.first): Question.fromJson(
						int.parse(q.keys.first),
						q[q.keys.first] as Map<String, dynamic>
					)
			};
			notifyListeners();
			return true;
		}
		return false;
	}

	Future<void> _updateCache() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(
			'questions_cache',
			json.encode(_questions.questoes.entries.map((e) => {e.key.toString(): e.value.toJson()}).toList())
		);
	}

	Future<void> syncAllQuestionsDatabaseToLocal(BuildContext context) async {
		if (_hasSynced) return;

		// Primeiro tenta carregar do cache
		final hasCache = await _loadFromCache();
		if (hasCache) {
			_hasSynced = true;
			return;
		}

		// Se não houver cache, sincroniza com o banco de dados
		if(context.mounted){
			final dbProvider = Provider.of<QuestionDatabaseProvider>(context, listen: false);
			final syncedQuestions = await dbProvider.syncToLocal();
			if (syncedQuestions != null) {
				_questions = syncedQuestions;
				_questions.getQuantQuestion();
			}
		}
		
		await _updateCache();
		_hasSynced = true;
		notifyListeners();
	}

	Map<int, Question> get allQuestions => _questions.questoes;
}
