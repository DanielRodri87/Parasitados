import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/database/question_database.dart';

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
		questions = await Questions.fromJsonFile(jsonPath);
		
		// Conectar ao Redis
		bool retorno = await db.connectRedis();
		db.loadQuestionsToRedis(jsonPath);
		Map<String, dynamic>? questao = await db.getQuestion(1);
		expect(retorno, true);
		expect(questions.getQuestion(1)!.enunciado, questao!['pergunta']);
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

void testeAddOrUpdateQuestion() {
	test('Testa addOrUpdateQuestion insere e recupera corretamente', () async {
		final db = QuestionDatabase();
		await db.connectRedis();

		final int id = 9999;
		final Map<String, dynamic> question = {
			'pergunta': 'Pergunta de teste',
			'resposta': 'a',
			'alternativas': [
				{'a': 'Alternativa A'},
				{'b': 'Alternativa B'},
				{'c': 'Alternativa C'},
				{'d': 'Alternativa D'},
			]
		};

		await db.addOrUpdateQuestion(id, question);
		final result = await db.getQuestion(id);

		expect(result, isNotNull);
		expect(result!['pergunta'], 'Pergunta de teste');
		expect(result['alternativas'][0]['a'], 'Alternativa A');
	});
}

void main() async {
	await dotenv.load(fileName: ".env");
	testeConexaoRedis();
	// testeInserirDadosRedis();
	testeLerDadosRedis();
	testeAddOrUpdateQuestion();
}