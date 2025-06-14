import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/database/question_database.dart';

class QuestionDatabaseProvider extends ChangeNotifier {
	final QuestionDatabase _db = QuestionDatabase();
	bool _isConnected = false;
	bool get isConnected => _isConnected;
	bool _isConnecting = false;

	QuestionDatabase get db => _db;

	Future<void> _initOnce() async {
		if (!_isConnected && !_isConnecting) {
			_isConnecting = true;
			_isConnected = await _db.connectRedis();
			_isConnecting = false;
			notifyListeners();
		}
	}

	Future<void> connect() async {
		await _initOnce();
	}

	Future<void> reloadQuestionsFromJson(String jsonPath) async {
		await _db.loadQuestionsToRedis(jsonPath);
		notifyListeners();
	}

	Future<Map<int, dynamic>> getAllQuestions() async {
		return await _db.getAllQuestions();
	}

	Future<Map<String, dynamic>?> getQuestion(int id) async {
		return await _db.getQuestion(id);
	}

	Future<int> addOrUpdateQuestion(int id, Map<String, dynamic> question) async {
		int retorno = -1;
		await _db.addOrUpdateQuestion(id, question);
		retorno = id;
		notifyListeners();
		return retorno;
	}

	Future<Questions?> syncToLocal() async {
		return await _db.databaseToLocal();
	}
}
