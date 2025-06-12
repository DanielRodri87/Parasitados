import 'package:flutter/material.dart';
import 'package:parasitados/database/question_database.dart';

void main() async {
  final db = QuestionDatabase();

  // Conectar ao Redis
  await db.connectRedis();

  // Carregar questões do JSON para o Redis
  await db.loadQuestionsToRedis('assets/pdf/questions.json');
  debugPrint('Questões carregadas no Redis!');

  // Buscar todas as questões do Redis
  final questions = await db.getAllQuestions();
  debugPrint('Questões recuperadas do Redis:');
  debugPrint('$questions');

  // Adicionar/atualizar uma questão
  await db.addOrUpdateQuestion(999, {
    "pergunta": "Teste de inserção",
    "resposta": "a",
    "alternativas": [
      {"a": "Alternativa A"},
      {"b": "Alternativa B"},
      {"c": "Alternativa C"},
      {"d": "Alternativa D"}
    ]
  });
  debugPrint('Questão 999 adicionada/atualizada!');

  // Sincronizar (buscar todas as questões)
  final sync = await db.syncQuestions();
  debugPrint('Sincronização:');
  debugPrint('$sync');
}