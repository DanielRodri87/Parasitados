
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/questions.dart';

void testeQuestoesJson(){
	test("Testa o recebimento das questoes do json", () async {
		final questions = await Questions.fromJsonFile();
		// Testa se a resposta da primeira questão é "d"
		expect(questions.questoes[1]?.respostaCorreta, 4); // 'd' vira 4
	});
}

void main(){
	testeQuestoesJson();
}