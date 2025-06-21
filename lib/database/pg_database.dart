import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'postgres_local_helper.dart';

class PgDatabase {
	bool usePostgresLocal = true;
	SupabaseClient? supabase;
	PostgresLocalHelper? pgHelper;

	PgDatabase() {
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
}