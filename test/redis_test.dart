import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/database/question_database.dart';
import 'package:parasitados/service/question_sync_service.dart';

void testeConexaoRedis(){
	test("Testando conexao com o redis", () async {
		final QuestionDatabase db = QuestionDatabase();

		// Conectar ao Redis
		bool retorno = await db.connectRedis();
		expect(retorno, true);
	});
}

void testeInserirDadosRedis(){
	test("Testando enviar dados para o redis", () async {
		String jsonPath = 'assets/pdf/questions.json';
		final QuestionDatabase db = QuestionDatabase();
		Questions questions = Questions();
		questions = await Questions.fromJsonFile();
		
		await db.connectRedis();
		await db.loadQuestionsToRedis(jsonPath);

		Map<String, dynamic>? questao = await db.getQuestion(1);
		expect(questions.getQuestion(1)!.enunciado, questao!['pergunta']);
	});
}

void testeQuantidadeQuestoesRedis() {
	test("Testando se a quantidade de questões no Redis é igual ao JSON", () async {
		final db = QuestionDatabase();
		await db.connectRedis();

		// Carrega questões do JSON
		final questions = await Questions.fromJsonFile();
		final int quantJson = questions.quantQuestion;

		// Carrega questões do Redis
		final allQuestionsRedis = await db.getAllQuestions();
		final int quantRedis = allQuestionsRedis.length;

		expect(quantRedis, quantJson);
	});
}

void testeLerDadosRedis(){
	test("Testando Ler dados do redis", () async {
		final QuestionDatabase db = QuestionDatabase();
		await db.connectRedis();

		Map<String, dynamic>? questao = await db.getQuestion(1);
		expect(questao!['pergunta'], 'Qual sistema é preferencialmente afetado pela Leishmania sp no organismo do hospedeiro?');
	});
}

void testeSincronizacao() {
	test('Testa sincronização add, update e del no JSON e Redis via QuestionSyncService', () async {
		// Setup
		final questions = await Questions.fromJsonFile();
		final db = QuestionDatabase();
		await db.connectRedis();

		// ADD
		final Map<String, dynamic> questionData = {
			'pergunta': 'Pergunta de sync teste',
			'resposta': 'a',
			'alternativas': [
				{'a': 'A'},
				{'b': 'B'},
				{'c': 'C'},
				{'d': 'D'},
			]
		};
		final addResult = await QuestionSyncService.addQuestionSync(
			questionData: questionData,
			questions: questions,
			db: db,
		);
		expect(addResult, questions.quantQuestion,reason: 'Ids diferentes, tome cuidado');
		debugPrint('$addResult == ${questions.quantQuestion}');

		// UPDATE
		final int lastId = questions.id;
		final updatedQuestion = Question(
			id: lastId,
			enunciado: 'Pergunta de sync teste atualizada',
			opcoes: [
				{'a': 'A'},
				{'b': 'B'},
				{'c': 'C'},
				{'d': 'D'},
			],
			respostaCorreta: 1,
		);
		final updateResult = await QuestionSyncService.updateQuestionSync(
			id: lastId,
			question: updatedQuestion,
			questions: questions,
			db: db,
		);
		expect(updateResult, true);

		// DEL
		final delResult = await QuestionSyncService.delQuestionSync(
			id: lastId,
			questions: questions,
			db: db,
		);
		expect(delResult, true);
	});
}

void testeIdsPresentesNoRedis() {
	test('Verifica ids presentes no Redis mas não no JSON', () async {
		final db = QuestionDatabase();
		await db.connectRedis();

		// Carrega ids do Redis
		final allQuestionsRedis = await db.getAllQuestions();
		final redisIds = allQuestionsRedis.keys.toSet();

		// Carrega ids do JSON
		final data = await Questions.getAllQuestionsJson(Questions.jsonPath);
		final jsonIds = data.map((q) => int.parse(q.keys.first)).toSet();

		// Descobre ids que estão no Redis mas não no JSON
		final onlyInRedis = redisIds.difference(jsonIds);
		debugPrint('IDs presentes no Redis mas não no JSON: $onlyInRedis');
		expect(onlyInRedis.isEmpty, true, reason: 'Existem ids no Redis que não estão no JSON');
	});
}

void main() async {
	await dotenv.load(fileName: ".env");
	testeConexaoRedis();
	testeInserirDadosRedis();
	testeLerDadosRedis();
	testeSincronizacao();
	testeQuantidadeQuestoesRedis();
	testeIdsPresentesNoRedis();
}