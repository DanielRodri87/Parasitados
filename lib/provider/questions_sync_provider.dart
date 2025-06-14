import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/database/question_database.dart';
import 'package:parasitados/service/question_sync_service.dart';

class QuestionsSyncProvider extends ChangeNotifier {
	Future<void> loadFromJson({
		required Questions questions
	}
	) async {
		final loaded = await Questions.fromJsonFile();
		questions.questoes = loaded.questoes;
		questions.id = loaded.id;
		notifyListeners();
	}

	Future<int> addQuestion(
		Map<String, dynamic> questionData,
		{
			required Questions questions,
			required QuestionDatabase db,
		}
	) async {
		final result = await QuestionSyncService.addQuestionSync(
			questionData: questionData,
			questions: questions,
			db: db,
		);
		notifyListeners();
		return result;
	}

	Future<bool> updateQuestion(
		int id, Question question,
		{
			required Questions questions,
			required QuestionDatabase db,
		}
	) async {
		final result = await QuestionSyncService.updateQuestionSync(
			id: id,
			question: question,
			questions: questions,
			db: db,
		);
		notifyListeners();
		return result;
	}

	Future<bool> delQuestion(
		int id,
		{
			required Questions questions,
			required QuestionDatabase db,
		}
	) async {
		final result = await QuestionSyncService.delQuestionSync(
			id: id,
			questions: questions,
			db: db,
		);
		notifyListeners();
		return result;
	}

	Question? getQuestion(
		int id,
		{
			required Questions questions,
		}
	) {
		return questions.getQuestion(id);
	}
}
