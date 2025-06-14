import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/database/question_database.dart';
import 'package:parasitados/provider/questions_provider.dart';
import 'package:provider/provider.dart';

class QuestionDatabaseProvider extends ChangeNotifier {
	final QuestionDatabase _db = QuestionDatabase();
	bool _isConnected = false;
	bool get isConnected => _isConnected;
	bool _isConnecting = false;

	QuestionDatabase get db => _db;

	Future<void> connect() async {
		if (!_isConnected && !_isConnecting) {
			_isConnecting = true;
			_isConnected = await _db.connectRedis();
			_isConnecting = false;
			notifyListeners();
		}
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

	Future<int> updateQuestion(int id, Map<String, dynamic> question) async {
		int retorno = -1;
		await _db.updateQuestion(id, question);
		retorno = id;
		notifyListeners();
		return retorno;
	}

	Future<int> addQuestion(Map<String, dynamic> question, BuildContext context) async {
		int retorno = -1;
		Questions questions = Provider.of<QuestionsProvider>(context,listen:false).questions;
		
		retorno = await _db.addQuestion(questions, question);
		
		notifyListeners();
		return retorno;
	}

	Future<Questions?> syncToLocal() async {
		return await _db.databaseToLocal();
	}
}
