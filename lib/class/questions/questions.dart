import 'dart:convert';
import 'dart:io';
import 'package:parasitados/class/questions/question.dart';
import 'package:csv/csv.dart';

class Questions {
  int id = 0;
  Map<int, Question> questoes = {};
  static const String csvPath = 'assets/pdf/questoes_md_formatadas.csv';
  int get quantQuestion => questoes.length;

  static Future<Questions> fromCsvFile() async {
    final file = File(csvPath);
    final csvString = await file.readAsString();
    final rows = const CsvToListConverter(
      eol: '\n',
      fieldDelimiter: ',',
    ).convert(csvString, shouldParseNumbers: false);
    final questions = Questions();
    // pula header
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      // campos: topico,numero,pergunta,alternativa_a,alternativa_b,alternativa_c,alternativa_d,alternativa_e,resposta
      final id = int.tryParse(row[1].toString()) ?? i;
      final topico = row[0];
      final List<String> opcoes = [row[3], row[4], row[5], row[6]];
      if (row[7] != null && row[7].toString().trim().isNotEmpty) {
        opcoes.add(row[7]);
      }
      final respostaLetra = row[8]?.toString().toUpperCase() ?? '';
      final respostaCorreta =
          respostaLetra.isNotEmpty
              ? respostaLetra.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1
              : 0;
      questions.questoes[id] = Question(
        id: id,
        topico: topico,
        enunciado: row[2] ?? '',
        opcoes: opcoes,
        respostaCorreta: respostaCorreta,
      );
    }
    if (questions.questoes.isNotEmpty) {
      questions.id = questions.questoes.keys.reduce((a, b) => a > b ? a : b);
    } else {
      questions.id = 0;
    }
    return questions;
  }

  static Future<List<dynamic>> getAllQuestionsJson(String jsonPath) async {
    final file = File(jsonPath);
    final jsonString = await file.readAsString();
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  Question? getQuestion(int id) {
    return questoes[id];
  }

  List<Question> questoesTopico(String topico) {
    return questoes.values.where((q) => q.topico == topico).toList();
  }
}
