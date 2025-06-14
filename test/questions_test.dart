
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/questions.dart';

void testeQuestoesJson(){
	test("Testa o recebimento das questoes do json", () async {
		final questions = await Questions.fromJsonFile("assets/pdf/questions.json");
		// Testa se a resposta da primeira questão é "d"
		expect(questions.questoes[1]?.respostaCorreta, 4); // 'd' vira 4
	});
}

void addQuestoesQuestion(){
	test("Testa o metodo adicionar de Questions", () async {
		final questions = await Questions.fromJsonFile("assets/pdf/questions.json");
		// Testa se a resposta da primeira questão é "d"
		int quantidade = questions.id;
		await questions.addQuestion("assets/pdf/questions.json",{
			"pergunta": "Quais são as duas formas evolutivas apresentadas pela Leishmania sp?",
			"resposta": "b",
			"alternativas": [
				{
				"a": "Amastigota e tripomastigota"
				},
				{
				"b": "Amastigota e promastigota"
				},
				{
				"c": "Epimastigota e promastigota"
				},
				{
				"d": "Tripomastigota e epimastigota"
				}
			]
			});

		expect(questions.id, quantidade+1); // 'd' vira 4
	});
}

void main(){
	testeQuestoesJson();
	addQuestoesQuestion();
}