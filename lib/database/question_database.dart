import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';
import 'package:upstash_redis/upstash_redis.dart' as upstash;
import 'package:redis/redis.dart' as localredis;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';

class QuestionDatabase {
	bool useUpstash = false; // Altere para false para usar Redis local
	upstash.Redis? _upstashRedis;
	localredis.Command? _localRedis;

	Future<bool> connectRedis() async {
		bool retorno = false;
		if (useUpstash) {
			await dotenv.load(fileName: ".env");
			final url = dotenv.env['UPSTASH_REDIS_REST_URL']!;
			final token = dotenv.env['UPSTASH_REDIS_REST_TOKEN']!;
			try {
				_upstashRedis = upstash.Redis(url: url, token: token);
				retorno = true;
				debugPrint('Conectado ao redis upstash');
			} catch (e) {
				debugPrint("Erro ao conectar ao banco UPSTASH!");
			}
		} else {
			try {
				final conn = localredis.RedisConnection();
				_localRedis = await conn.connect('localhost', 6379);
				retorno = true;
				debugPrint('Conectado ao redis localmente');
			} catch (e) {
				debugPrint("Erro ao conectar ao Redis local!");
			}
		}
		return retorno;
	}

	// Exemplo de uso para HSET
	Future<void> hset(String key, Map<String, dynamic> value) async {
		if (useUpstash) {
		await _upstashRedis!.hset('questions', value);
		} else {
		await _localRedis!.send_object(['HSET', 'questions', ...value.entries.expand((e) => [e.key, e.value is String ? e.value : json.encode(e.value)])]);
		}
	}

	// Exemplo de uso para HGETALL
	Future<Map<dynamic, dynamic>?> hgetall(String key) async {
		if (useUpstash) {
		return await _upstashRedis!.hgetall(key);
		} else {
		final result = await _localRedis!.send_object(['HGETALL', key]);
		if (result is List) {
			final map = <dynamic, dynamic>{};
			for (int i = 0; i < result.length; i += 2) {
			map[result[i]] = result[i + 1];
			}
			return map;
		}
		return null;
		}
	}

	// Carrega perguntas do arquivo JSON e insere no Redis
	Future<void> loadQuestionsToRedis(String jsonPath) async {
		final file = File(jsonPath);
		final jsonString = await file.readAsString();
		final List<dynamic> data = json.decode(jsonString);
		for (var q in data) {
		q.forEach((key, value) async {
			await hset('questions', {key: json.encode(value)});
		});
		}
	}

	// Adiciona/atualiza uma questão no Redis
	Future<void> addOrUpdateQuestion(int id, Map<String, dynamic> question) async {
		await hset('questions', {id.toString(): json.encode(question)});
	}

	// Busca todas as questões do Redis
	Future<Map<int, dynamic>> getAllQuestions() async {
		final result = await hgetall('questions');
		final Map<int, dynamic> questions = {};
		result?.forEach((key, value) {
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