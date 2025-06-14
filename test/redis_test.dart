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
		final int quantJson = questions.getQuantQuestion();

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

void testeUpdateQuestion() {
	test('Testa updateQuestion atualiza a pergunta corretamente', () async {
		final db = QuestionDatabase();
		await db.connectRedis();

		final int id = 1;
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

		await db.updateQuestion(id, question);
		final result = await db.getQuestion(id);

		expect(result, isNotNull);
		expect(result!['pergunta'], 'Pergunta de teste');
		expect(result['alternativas'][0]['a'], 'Alternativa A');
	});
}

void testeAddQuestion() {
	test('Testa addQuestion insere e recupera corretamente', () async {
		final db = QuestionDatabase();
		await db.connectRedis();

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
		Questions questions = await db.databaseToLocal();
		await db.addQuestion(questions, question);
		final result = await db.getQuestion(questions.getQuantQuestion());

		expect(result!['pergunta'], 'Pergunta de teste');
		db.delQuestion(questions.getQuantQuestion());
	});
}

void main() async {
	await dotenv.load(fileName: ".env");
	testeConexaoRedis();
	testeInserirDadosRedis();
	testeLerDadosRedis();
	testeQuantidadeQuestoesRedis();
	testeUpdateQuestion();
	testeAddQuestion();
}