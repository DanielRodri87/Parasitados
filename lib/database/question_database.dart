import 'dart:convert';
import 'dart:io';
import 'package:redis/redis.dart';

//Quero fazer com que o banco se conecte ao redis insira os dados .json no redis
//Depois, quando ja tiver as perguntas, quero adicionar dados ao redis e salvar
//E passe para todos os celulares as questões atualizadas

class QuestionDatabase {
  late RedisConnection _connection;
  late Command _redis;

  // Conecta ao Redis
  Future<void> connectRedis({String host = 'localhost', int port = 6379}) async {
    _connection = RedisConnection();
    _redis = await _connection.connect(host, port);
  }

  // Carrega perguntas do arquivo JSON e insere no Redis
  Future<void> loadQuestionsToRedis(String jsonPath) async {
    final file = File(jsonPath);
    final jsonString = await file.readAsString();
    final List<dynamic> data = json.decode(jsonString);
    for (var q in data) {
      q.forEach((key, value) async {
        await _redis.send_object(['HSET', 'questions', key, json.encode(value)]);
      });
    }
  }

  // Adiciona/atualiza uma questão no Redis
  Future<void> addOrUpdateQuestion(int id, Map<String, dynamic> question) async {
    await _redis.send_object(['HSET', 'questions', id.toString(), json.encode(question)]);
  }

  // Busca todas as questões do Redis
  Future<Map<String, dynamic>> getAllQuestions() async {
    final result = await _redis.send_object(['HGETALL', 'questions']);
    final Map<String, dynamic> questions = {};
    for (int i = 0; i < result.length; i += 2) {
      questions[result[i]] = json.decode(result[i + 1]);
    }
    return questions;
  }

  // Sincroniza questões para todos os dispositivos (exemplo: retorna todas as questões)
  Future<List<Map<String, dynamic>>> syncQuestions() async {
    final all = await getAllQuestions();
    return all.entries.map((e) => {e.key: e.value}).toList();
  }

}