import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;

class LoginDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String dbPath = path_package.join(databasesPath, 'login.db');

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE login(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome1 TEXT,
            nome2 TEXT,
            foto1 TEXT,
            foto2 TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE questions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            enunciado TEXT NOT NULL,
            opcao_a TEXT NOT NULL,
            opcao_b TEXT NOT NULL,
            opcao_c TEXT NOT NULL,
            opcao_d TEXT NOT NULL,
            resposta_correta INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}