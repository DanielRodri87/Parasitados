import 'package:postgres/postgres.dart';

class PostgresLocalHelper {
	final String host;
	final int port;
	final String database;
	final String username;
	final String password;
	late Connection _connection;

	PostgresLocalHelper({
		required this.host,
		this.port = 5432,
		required this.database,
		required this.username,
		required this.password,
	});

	Future<void> connect() async {
		_connection = await Connection.open(
			Endpoint(
				host: host,
				database: database,
				username: username,
				password: password,

			),
			settings: ConnectionSettings(
				sslMode: SslMode.disable
			)
		);
	}

	Future<void> close() async {
		await _connection.close();
	}

	Future<Map<String, dynamic>?> query(String sql, {Map<String, dynamic>? substitutionValues}) async {
		final result = await _connection.execute(
			Sql.named(sql),
			parameters: substitutionValues,
		);
		if (result.isEmpty) return null;
		return result.first.toColumnMap();
	}

	Future<List<Map<String, dynamic>>> queryAll(String sql, {Map<String, dynamic>? substitutionValues}) async {
		final result = await _connection.execute(
			Sql.named(sql),
			parameters: substitutionValues,
		);

		return result.map((row) => row.toColumnMap()).toList();
	}

	Future<int> execute(String sql,
		{Map<String, dynamic>? substitutionValues}) async {
			
		final result = await _connection.execute(
			Sql.named(sql),
			parameters: substitutionValues
		);
		return result.affectedRows;
	}
}
