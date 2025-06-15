import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/database/question_database.dart';

class QuestionSyncService {
	
	static Future<int> addQuestionSync({
		required Map<String, dynamic> questionData,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		int retorno = -1;
		int localResult = await questions.addQuestion(questionData);
		int redisResult = await db.addQuestion(questions, questionData);

		if (localResult != redisResult) {
			await questions.delQuestion(localResult);
			await db.delQuestion(redisResult);
		}else{
			retorno = redisResult;
		}

		return retorno;
	}

	static Future<bool> delQuestionSync({
		required int id,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		bool localResult = await questions.delQuestion(id);
		bool redisResult = await db.delQuestion(id);
		return localResult && redisResult;
	}

	static Future<bool> updateQuestionSync({
		required int id,
		required Question question,
		required Questions questions,
		required QuestionDatabase db,
	}) async {
		bool localResult = await questions.updateQuestion(id, question);
		await db.updateQuestion(id, question.toJson());
		return localResult;
	}
}
