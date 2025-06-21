import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/database/question_database.dart';

class QuestionSyncService {
	static Future<int> addQuestionSync({
		required Question questionData,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		int retorno = -1;
		int supabaseResult = await db.addQuestion(questions, questionData);

		retorno = supabaseResult;

		return retorno;
	}

	static Future<bool> delQuestionSync({
		required int id,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		bool supabaseResult = await db.delQuestion(id);
		return supabaseResult;
	}

	static Future<bool> updateQuestionSync({
		required int id,
		required Question question,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		bool localResult = await db.updateQuestion(questions, question);
		return localResult;
	}
}
