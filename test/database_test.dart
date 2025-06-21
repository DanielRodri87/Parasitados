import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:parasitados/database/question_database.dart';

// Por enquanto, impossivel testar o supabase

void testeConexaoBanco({bool usePostgresLocal = true}){
	test("Testando conexao com o banco", () async {
		final QuestionDatabase db = QuestionDatabase();
    	db.pgDatabase!.usePostgresLocal = usePostgresLocal;
		bool retorno = await db.connect();
		expect(retorno, true);
	});
}

void testeInserirDadosBanco({bool usePostgresLocal = true}){
	test("Testando enviar dados para o banco", () async {
		final QuestionDatabase db = QuestionDatabase();
    	db.pgDatabase!.usePostgresLocal = usePostgresLocal;
		
		Questions questions = await Questions.fromCsvFile();
		Question? questionData;
		try {
			questionData = questions.getQuestion(1)!;
		} catch (e) {
			debugPrint("$e");
		}

		// Serializa os dados para JSON antes de enviar ao banco
		await db.addQuestion(questions, questionData!);
		expect(1, 1);
	});
}

void testeDeletarDadosBanco({bool usePostgresLocal = true}){
	test("Testando enviar dados para o banco", () async {
		final QuestionDatabase db = QuestionDatabase();
    	db.pgDatabase!.usePostgresLocal = usePostgresLocal;
		
		// Serializa os dados para JSON antes de enviar ao banco
		final retorno = await db.delQuestion(6);

		// Use the correct column name as in your database, e.g., 'pergunta' instead of 'enunciado'
		expect(retorno, true);
	});
}

void testeLerDadosBanco({bool usePostgresLocal = true}){
	test("Testando Ler dados do banco", () async {
		final QuestionDatabase db = QuestionDatabase();
    	db.pgDatabase!.usePostgresLocal = usePostgresLocal;
		final questao = await db.getQuestion(12);

		expect(questao!['pergunta'], 'A transmissão mecânica é uma característica importante na epidemiologia de qual das seguintes espécies de Trypanosoma?');
	});
}

void testeLerTodosOsDados({bool usePostgresLocal = true}) {
	test("Testando Ler todos os dados do banco", () async {
		final QuestionDatabase db = QuestionDatabase();
		db.pgDatabase!.usePostgresLocal = usePostgresLocal;
		await db.connect();
		final result = await db.getAllQuestions();

		expect(result[1]["topico"], "PROTOZOÁRIOS");
	});
}

void testeImportarTodasQuestoesCsvBanco({bool usePostgresLocal = true}){
	test("Testando importar todas as questões do CSV para o banco", () async {
		if(usePostgresLocal){
			final QuestionDatabase db = QuestionDatabase();
			db.pgDatabase!.usePostgresLocal = usePostgresLocal;
			await db.importAllFromCsv();
			final questoes = await db.getAllQuestions();
			// Espera que pelo menos uma questão tenha sido importada
			expect(questoes.isNotEmpty, true);
			// Verifica se a primeira questão bate com o CSV
			expect(questoes[1]['pergunta'], 'Qual sistema é preferencialmente afetado pela *Leishmania* sp no organismo do hospedeiro?');
		}
	});
}

void main() {
  bool useLocal = true;

  testeConexaoBanco(usePostgresLocal: useLocal);
  testeInserirDadosBanco(usePostgresLocal: useLocal);
  testeDeletarDadosBanco(usePostgresLocal: useLocal);
  testeLerDadosBanco(usePostgresLocal: useLocal);
  testeLerTodosOsDados(usePostgresLocal: useLocal);
  testeImportarTodasQuestoesCsvBanco(usePostgresLocal: useLocal);
}