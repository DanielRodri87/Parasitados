import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';

void testeQuestoesJson(){
	test("Testa o recebimento das questoes do json", () async {
		final questions = await Questions.fromCsvFile();
		// Testa se a resposta da primeira questão é "d"
		expect(questions.questoes[1]?.opcoes[0], "Sistema digestório"); 
		expect(questions.questoes[1]?.opcoes.runtimeType, List<String>); 
		expect(questions.questoes[1]?.topico, "PROTOZOÁRIOS"); 
		expect(questions.questoes[1]?.respostaCorreta, 4); 
	});
}

void testeConverteResposta(){
	test("Testa o recebimento das questoes do json", () async {
		final texto = Question.parseRespostaString(1);
		debugPrint(texto);
	});
}

void main(){
	testeQuestoesJson();
}