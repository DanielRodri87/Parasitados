import 'package:parasitados/database/pg_database.dart';
import 'package:parasitados/database/user_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankingDatabase {
	PgDatabase? pgDatabase;

  	RankingDatabase(){
		pgDatabase = PgDatabase();
	}
	
	Future<int> inserirRanking({
		required int qtdAcertos,
		required double taxaDeAcerto,
		required double tempoRealizado,
	}) async {
		int retorno = 0;
		final Map<String, dynamic>? user = await UserDatabase.lerUserLocal();		
		if(!(user!['onDb'] as bool)){
			try {
				if(pgDatabase!.usePostgresLocal){
					await pgDatabase?.pgHelper?.connect();
					
					await pgDatabase?.pgHelper?.execute(
						'INSERT INTO ranking_jogadores (id_da_pessoa, qtd_acertos, taxa_de_acerto, tempo_realizado) VALUES (@id_da_pessoa, @qtd_acertos, @taxa_de_acerto, @tempo_realizado)',
						substitutionValues: {
							'id_da_pessoa': user["id"],
							'qtd_acertos': qtdAcertos,
							'taxa_de_acerto': taxaDeAcerto,
							'tempo_realizado': tempoRealizado,
						},
					);
					await pgDatabase?.pgHelper?.close();
				}else{
					await pgDatabase!.supabase!.from('ranking_jogadores').upsert({
						'id_da_pessoa': user["id"],
						'qtd_acertos': qtdAcertos,
						'taxa_de_acerto': taxaDeAcerto,
						'tempo_realizado': tempoRealizado,
					}).select();
				}
				
				final prefs = await SharedPreferences.getInstance();
				await prefs.setBool('on_db', true);

				retorno = 1;
			} catch (e) {
				retorno = -1;
			}
		}

		return retorno;
	}

	Future<void> atualizarRanking({
		required int qtdAcertos,
		required double taxaDeAcerto,
		required double tempoRealizado,
	}) async {
		final Map<String, dynamic>? user = await UserDatabase.lerUserLocal();		

		if(user != null){
			if(pgDatabase!.usePostgresLocal){
				await pgDatabase?.pgHelper?.connect();
				await pgDatabase?.pgHelper?.execute(
					'UPDATE ranking_jogadores SET qtd_acertos = @qtd_acertos, taxa_de_acerto = @taxa_de_acerto, tempo_realizado = @tempo_realizado WHERE id_da_pessoa = @id_da_pessoa',
					substitutionValues: {
						'id_da_pessoa': user["id"],
						'qtd_acertos': qtdAcertos,
						'taxa_de_acerto': taxaDeAcerto,
						'tempo_realizado': tempoRealizado,
					},
				);
				await pgDatabase?.pgHelper?.close();
			}else{
				await pgDatabase!.supabase!.from('ranking_jogadores').update({
					'id_da_pessoa': user["id"],
					'qtd_acertos': qtdAcertos,
					'taxa_de_acerto': taxaDeAcerto,
					'tempo_realizado': tempoRealizado,
				}).eq('id_da_pessoa', user['id']);
			}
		}
	}

	Future<Map<String, dynamic>?> getRankingPorId(int id) async {
		Map<String, dynamic>? resultado;
		try {
			if (pgDatabase!.usePostgresLocal) {
				await pgDatabase?.pgHelper?.connect();
				final rows = await pgDatabase?.pgHelper?.query(
					'SELECT * FROM ranking_jogadores WHERE id_da_pessoa = @id',
					substitutionValues: {'id': id},
				);
				await pgDatabase?.pgHelper?.close();
				if (rows != null) {
					resultado = Map<String, dynamic>.from(rows);
					// Transforma taxa_de_acerto em porcentagem
					if (resultado['taxa_de_acerto'] != null) {
					resultado['taxa_de_acerto'] =
						((resultado['taxa_de_acerto'] as double) * 100);
					}
				}
			} else {
				final response = await pgDatabase!.supabase!
					.from('ranking_jogadores')
					.select()
					.eq('id_da_pessoa', id)
					.limit(1);
				if (response.isNotEmpty) {
				resultado = Map<String, dynamic>.from(response.first);
				}
			}
		} catch (e) {
			resultado = null;
		}
		return resultado;
  	}

	Future<int?> getRankingPosicaoPorId(int id) async {
		try {
			if (pgDatabase!.usePostgresLocal) {
				await pgDatabase?.pgHelper?.connect();
				final rows = await pgDatabase?.pgHelper?.query(
					'''
					WITH dados AS (
						SELECT
							r.id_da_pessoa,
							p.nome,
							r.qtd_acertos,
							r.taxa_de_acerto,
							r.tempo_realizado,
							MIN(r.tempo_realizado) OVER () AS min_tempo,
							MAX(r.qtd_acertos) OVER () AS max_acertos
						FROM ranking_jogadores r
						JOIN pessoas p ON r.id_da_pessoa = p.id
					),
					scores AS (
						SELECT
							*,
							(CASE WHEN tempo_realizado = 0 THEN 0 ELSE min_tempo / tempo_realizado END) AS tempo_normalizado,
							((qtd_acertos::float / NULLIF(max_acertos,0)) * 0.2 + (taxa_de_acerto * 0.4) +
							 (CASE WHEN tempo_realizado = 0 THEN 0 ELSE (min_tempo / tempo_realizado) END * 0.4)) AS score
						FROM dados
					),
					ordenado AS (
						SELECT
							*,
							ROW_NUMBER() OVER (ORDER BY score DESC) AS posicao,
							COUNT(*) OVER () AS total
						FROM scores
					)
					SELECT posicao
					FROM ordenado
					WHERE id_da_pessoa = @id
					''',
					substitutionValues: {'id': id},
				);
				await pgDatabase?.pgHelper?.close();
				if (rows != null) {
					return rows['posicao'];
				}
			} else {
				final response = await pgDatabase!.supabase!
					.rpc('get_ranking_por_id', params: {'id_user': id});

				if (response == null) return null;
				if (response is int) {
				  return response;
				}
				return null;
			}
			return null;
		} catch (e) {
			return null;
		}
	}
}