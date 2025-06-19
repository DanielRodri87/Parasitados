import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'postgres_local_helper.dart';

class QuestionDatabase {
  bool usePostgresLocal = true;
  SupabaseClient? supabase;
  PostgresLocalHelper? pgHelper;

  QuestionDatabase() {
    if (usePostgresLocal) {
      pgHelper = PostgresLocalHelper(
        host: Platform.isAndroid ? '10.0.2.2' : 'localhost',
        database: 'parasitados',
        username: 'postgres',
        password: 'postgres',
      );
    } else {
      supabase = Supabase.instance.client;
    }
  }

  Future<bool> connect() async {
    if (usePostgresLocal) {
      await pgHelper!.connect();
      return true;
    }
    return true;
  }

	Future<int> addQuestion(Questions questions, Question question, {bool allFunction = false}) async {
		int questionId = question.id ?? questions.quantQuestion + 1;
		if (usePostgresLocal) {
		if (!allFunction) await pgHelper!.connect();
		final alternativasList = question.opcoes;
		// Usa RETURNING id para pegar o id gerado
		final result = await pgHelper!.query(
			'INSERT INTO questions (topico, pergunta, alternativas, resposta) VALUES (@topico, @pergunta, @alternativas, @resposta) RETURNING id',
			substitutionValues: {
			'topico': question.topico,
			'pergunta': question.enunciado,
			'alternativas': '{${alternativasList.map((e) => '"$e"').join(',')}}',
			'resposta': Question.parseRespostaString(question.respostaCorreta),
			},
		);
		if (result != null && result['id'] != null) {
			questionId = result['id'] as int;
		}
		if (!allFunction) await pgHelper!.close();
		} else {
		final response = await supabase!.from('questions').upsert({
			'id': questionId,
			...question.toJson(),
		}).select();
		if (response.isNotEmpty && response[0]['id'] != null) {
			questionId = response[0]['id'] as int;
		}
		}
		questions.questoes[questionId] = question;
		return questionId;
	}

	Future<bool> delQuestion(int id) async {
		if (usePostgresLocal) {
			await pgHelper!.connect();

		await pgHelper!.execute('DELETE FROM questions WHERE id = @id', substitutionValues: {'id': id});
		} else {
		await supabase!.from('questions').delete().eq('id', id);
		}
		return true;
	}

	Future<bool> updateQuestion(Questions questions, Question question) async {
		final int? questionId = question.id;
		if (questionId == null) return false;

		if (usePostgresLocal) {
			await pgHelper!.connect();
			final alternativasList = question.opcoes;
			await pgHelper!.execute(
				'UPDATE questions SET topico = @topico, pergunta = @pergunta, alternativas = @alternativas, resposta = @resposta WHERE id = @id',
				substitutionValues: {
					'id': questionId,
					'topico': question.topico,
					'pergunta': question.enunciado,
					'alternativas': '{${alternativasList.map((e) => '"$e"').join(',')}}',
					'resposta': Question.parseRespostaString(question.respostaCorreta),
				},
			);
			await pgHelper!.close();
		} else {
			await supabase!.from('questions').update({
				...question.toJson(),
			}).eq('id', questionId);
		}
		questions.questoes[questionId] = question;
		return true;
	}


  Future<Map<int, dynamic>> getAllQuestions() async {
		final Map<int, dynamic> questions = {};
		if (usePostgresLocal) {
			await pgHelper!.connect();

			final result = await pgHelper!.queryAll('SELECT * FROM questions');
			debugPrint("$result");
			for (var row in result) {
				questions[int.parse(row['id'].toString())] = row;
			}
			return questions;
		} else {
			final List data = await supabase!.from('questions').select();
			for (var item in data) {
				questions[item['id']] = item;
			}
		}
		return questions;
  }

  Future<Map<String, dynamic>?> getQuestion(int id) async {
    if (usePostgresLocal) {
		await pgHelper!.connect();

      final result = await pgHelper!.query('SELECT * FROM questions WHERE id = @id', substitutionValues: {'id': id});
      if (result!.isNotEmpty) {
        return result;
      }
    } else {
      final List data = await supabase!.from('questions').select().eq('id', id);
      if (data.isNotEmpty) {
        return Map<String, dynamic>.from(data.first);
      }
    }
    return null;
  }

  Future<Questions> databaseToLocal() async {
	
    Map<int, dynamic> questoes = await getAllQuestions();
    late Questions questions = Questions();
    questions.questoes = Map.fromEntries(
      questoes.entries.map((entry) => MapEntry(entry.key, Question.fromJson(entry.key, entry.value)))
    );
    return questions;
  }

  Future<int> getNextQuestionIdFromCache(Questions questions) async {
    if (questions.questoes.isEmpty) {
      return 1;
    }
    final lastId = questions.questoes.keys.reduce((a, b) => a > b ? a : b);
    return lastId + 1;
  }

  	/// Importa todas as questões do CSV para o banco de dados
	Future<void> importAllFromCsv() async {
		// Lê todas as questões do CSV
		await pgHelper!.connect();
		
		final questions = await Questions.fromCsvFile();
		for (final question in questions.questoes.values) {
			await addQuestion(questions, question,
				allFunction:true
			);
		}

		await pgHelper!.close();

	}
}