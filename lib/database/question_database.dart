import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:upstash_redis/upstash_redis.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';

class QuestionDatabase {
	late final Redis _redis;

	Future<bool> connectRedis() async {
		bool retorno = false;

		await dotenv.load(fileName: ".env");
		final url = dotenv.env['UPSTASH_REDIS_REST_URL']!;
		final token = dotenv.env['UPSTASH_REDIS_REST_TOKEN']!;
		try {
			_redis = Redis(url: url, token: token);
			retorno = true;
		} catch (e) {
			debugPrint("Erro ao conectar ao banco!");
		}
		return retorno;
	}

	// Carrega perguntas do arquivo JSON e insere no Redis Upstash
	Future<void> loadQuestionsToRedis(String jsonPath) async {
		final file = File(jsonPath);
		final jsonString = await file.readAsString();
		final List<dynamic> data = json.decode(jsonString);
		for (var q in data) {
			q.forEach((key, value) async {
				await _redis.hset('questions', {key: json.encode(value)});
			});
		}
	}

	// Adiciona/atualiza uma questão no Redis Upstash
	Future<void> addOrUpdateQuestion(int id, Map<String, dynamic> question) async {
		await _redis.hset('questions', {id.toString(): json.encode(question)});
	}

	// Busca todas as questões do Redis Upstash
	Future<Map<int, dynamic>> getAllQuestions() async {
		final result = await _redis.hgetall('questions');
		final Map<int, dynamic> questions = {};
		result?.forEach((key, value) {
			// Garante que value é int antes de decodificar
			if (value is String) {
				questions[int.parse(key)] = json.decode(value);
			} else {
				questions[int.parse(key)] = value;
			}
		});
		return questions;
	}

	Future<Map<String, dynamic>?> getQuestion(int id) async {
		// Busca todas as questões e procura pelo id
		final all = await getAllQuestions();
		if (all.containsKey(id)) {
			return all[id];
		} else {
			debugPrint('No value found for id: $id');
			return null;
		}
	}

	Future<Questions> databaseToLocal() async {
		Map<int,dynamic> questoes = await getAllQuestions();
		late Questions questions = Questions();

		questions.questoes = Map.fromEntries(
		  questoes.entries.map((entry) => MapEntry(entry.key, Question.fromJson(entry.key, entry.value)))
		);

		return questions;
	}
}