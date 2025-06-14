import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/database/question_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionDatabaseProvider extends ChangeNotifier {
	final QuestionDatabase _db = QuestionDatabase();
	bool _isConnected = false;
	bool get isConnected => _isConnected;

	QuestionDatabase get db => _db;

	QuestionDatabaseProvider() {
		connect();
	}

	Future<void> connect() async {
		final prefs = await SharedPreferences.getInstance();
		if(prefs.getString('questions_cache') == null){
			_isConnected = await _db.connectRedis();
		}else{
			_isConnected = true;
		}
		notifyListeners();
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

	Future<void> addOrUpdateQuestion(int id, Map<String, dynamic> question) async {
		await _db.addOrUpdateQuestion(id, question);
		notifyListeners();
	}

	Future<Questions?> syncToLocal() async {
		if(!_isConnected){
			await connect();
			return await _db.databaseToLocal();
		}else{
			return null;
		}
	}
}
