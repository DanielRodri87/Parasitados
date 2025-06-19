import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/database/question_database.dart';
import 'package:parasitados/service/question_sync_service.dart';

class QuestionsSyncProvider extends ChangeNotifier {

	final QuestionDatabase _db = QuestionDatabase();
	Questions _questions = Questions();

	bool _isConnected = false;
	bool _isConnecting = false;
	bool _hasSynced = false;

	QuestionDatabase get db => _db;
	Questions get questions => _questions;
	bool get isConnected => _isConnected;
	Map<int, Question> get allQuestions => _questions.questoes;
	
	Future<void> connect() async {
		if (!_isConnected && !_isConnecting) {
			_isConnecting = true;
			_isConnected = await _db.connect();
			_isConnecting = false;
			notifyListeners();
		}
	}

	Future<Map<int, dynamic>> getAllQuestions() async {
		return await _db.getAllQuestions();
	}

	Future<Map<String, dynamic>?> getQuestion(int id) async {
		return await _db.getQuestion(id);
	}

	Future<Questions?> syncToLocal() async {
		return await _db.databaseToLocal();
	}

	Future<int> addQuestion(
		Question questionData,
	) async {
		final result = await QuestionSyncService.addQuestionSync(
			questionData: questionData,
			questions: questions,
			db: _db,
		);
		notifyListeners();
		return result;
	}

	Future<bool> updateQuestion(
		int id, Question question,
	) async {
		final result = await QuestionSyncService.updateQuestionSync(
			id: id,
			question: question,
			questions: questions,
			db: _db,
		);
		notifyListeners();
		return result;
	}

	Future<bool> delQuestion(
		int id,
	) async {
		final result = await QuestionSyncService.delQuestionSync(
			id: id,
			questions: questions,
			db: _db,
		);
		notifyListeners();
		return result;
	}

	Future<void> loadFromCSV() async {
		_questions = await Questions.fromCsvFile();
		notifyListeners();
	}
	
	Future<void> syncAllQuestionsDatabaseToLocal(BuildContext context) async {
		if (_hasSynced) return;

		Questions? loadedFromJson;
		try {
			loadedFromJson = await Questions.fromCsvFile();
		} catch (_) {
			loadedFromJson = null;
		}

		if (loadedFromJson != null && loadedFromJson.questoes.isNotEmpty) {
			_questions = loadedFromJson;
			_questions.quantQuestion;
			debugPrint('Carregado do json ${_questions.quantQuestion}');
		} else {
			if(!context.mounted) return;
			final syncedQuestions = await syncToLocal();
			if (syncedQuestions != null) {
				_questions = syncedQuestions;
			}
			debugPrint('Carregado do banco ${_questions.quantQuestion}');
		}

		_hasSynced = true;
		notifyListeners();
	}

}
