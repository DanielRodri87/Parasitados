import 'package:parasitados/database/pg_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDatabase {
	PgDatabase? pgDatabase;

	String? nome;
	int? id;

	UserDatabase.withData({
		this.nome,
		this.id
	}) {
		pgDatabase = PgDatabase();
	}

	Future<int> addUser(String nome) async {
		int idUSer = 0;
		final dados = await UserDatabase.lerUserLocal();

		this.nome = nome;
		
		if(dados == null){
			if(pgDatabase!.usePostgresLocal){
				await pgDatabase!.pgHelper!.connect();
				
				final result = await pgDatabase!.pgHelper!.query(
					'INSERT INTO pessoas (nome) VALUES (@nome) RETURNING id',
					substitutionValues: {
						'nome': nome,
					},
				);
				if (result != null && result['id'] != null) {
					idUSer = result['id'] as int;
				}

				await pgDatabase!.pgHelper!.close();
			}else{
				final response = await pgDatabase!.supabase!.from('pessoas').upsert({
					'nome': nome,
				}).select();
				if (response.isNotEmpty && response[0]['id'] != null) {
					idUSer = response[0]['id'] as int;
				}
			}
		}
		
		id = idUSer;
		
		return idUSer;
	}

	static Future<void> salvarUserLocal(String nome, int id) async {
		final user = await lerUserLocal();
		
		if(user == null){
			final prefs = await SharedPreferences.getInstance();
			await prefs.setString('user_nome', nome);
			await prefs.setInt('user_id', id);
			await prefs.setBool('on_db', false);
		}
	}

	static Future<Map<String, dynamic>?> lerUserLocal() async {
		final prefs = await SharedPreferences.getInstance();
		final nome = prefs.getString('user_nome');
		final id = prefs.getInt('user_id');
		final onDb = prefs.getBool('on_db');
		if (nome != null && id != null && onDb != null) {
			return {'nome': nome, 'id': id,'onDb':onDb};
		}
		return null;
	}

	static Future<void> limparDadosSharedPreference() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.clear(); // Remove todos os dados salvos
	}
}