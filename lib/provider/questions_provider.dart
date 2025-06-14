import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/provider/question_database_provider.dart';
import 'package:provider/provider.dart';

class QuestionsProvider extends ChangeNotifier {
	Questions _questions = Questions();
	Questions get questions => _questions;
	bool _hasSynced = false;

	Map<int, Question> get allQuestions => _questions.questoes;

	Future<void> loadFromJson() async {
		_questions = await Questions.fromJsonFile();
		notifyListeners();
	}

	Future<void> syncAllQuestionsDatabaseToLocal(BuildContext context) async {
		if (_hasSynced) return;

		// Tenta carregar do arquivo JSON primeiro
		Questions? loadedFromJson;
		try {
			loadedFromJson = await Questions.fromJsonFile();
		} catch (_) {
			loadedFromJson = null;
		}

		if (loadedFromJson != null && loadedFromJson.questoes.isNotEmpty) {
			_questions = loadedFromJson;
			_questions.quantQuestion;
			debugPrint('Carregado do json ${_questions.quantQuestion}');
		} else {
			if(!context.mounted) return;
			final dbProvider = Provider.of<QuestionDatabaseProvider>(context, listen: false);
			final syncedQuestions = await dbProvider.syncToLocal();
			if (syncedQuestions != null) {
				_questions = syncedQuestions;
			}
		}

		_hasSynced = true;
		notifyListeners();
	}
}
