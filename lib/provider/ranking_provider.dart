import 'package:flutter/material.dart';
import 'package:parasitados/database/ranking_database.dart';
import 'package:parasitados/database/user_database.dart';

class RankingProvider extends ChangeNotifier {
	final RankingDatabase _rankingDb = RankingDatabase();
	Map<String, dynamic>? _ranking;
	bool _isLoading = false;
	String? _error;
	int? _posicao;

	Map<String, dynamic>? get ranking => _ranking;
	bool get isLoading => _isLoading;
	String? get error => _error;
	int? get posicao => _posicao;

	Future<void> getRankingPorId() async {
		_isLoading = true;
		_error = null;
		
		try {
			final dados = await UserDatabase.lerUserLocal();
			_ranking = await _rankingDb.getRankingPorId(dados!['id']);
			_posicao = await _rankingDb.getRankingPosicaoPorId(dados['id']);
		} catch (e) {
			_error = e.toString();
			_ranking = null;
		}
		_isLoading = false;

		notifyListeners();
	}

	Future<int> inserirRanking({
		required int qtdAcertos,
		required double taxaDeAcerto,
		required double tempoRealizado,
	}) async {
		_isLoading = true;
		final result = await _rankingDb.inserirRanking(
			qtdAcertos: qtdAcertos,
			taxaDeAcerto: taxaDeAcerto,
			tempoRealizado: tempoRealizado,
		);
		_isLoading = false;
		notifyListeners();
		return result;
	}

	Future<void> atualizarRanking({
		required int qtdAcertos,
		required double taxaDeAcerto,
		required double tempoRealizado,
	}) async {
		_isLoading = true;
		await _rankingDb.atualizarRanking(
			qtdAcertos: qtdAcertos,
			taxaDeAcerto: taxaDeAcerto,
			tempoRealizado: tempoRealizado,
		);
		_isLoading = false;
		notifyListeners();
	}
}
