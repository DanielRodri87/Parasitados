import 'package:flutter/material.dart';
import 'package:parasitados/provider/questions_sync_provider.dart';
import 'package:parasitados/screen/about/about.dart';
import 'package:parasitados/screen/login/inicio_um_jogador.dart';
import 'package:parasitados/screen/login/mode_game.dart';
import 'package:parasitados/screen/questions/add_questions.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/questions/loading/loading_game_dois_jogador.dart';
import 'package:parasitados/screen/questions/loading/loading_game_um_jogador.dart';
import 'package:parasitados/screen/questions/questions_disponivel.dart';
import 'package:parasitados/screen/questions/roleta/roleta_screen_dois_jogador.dart';
import 'package:parasitados/screen/questions/roleta/roleta_screen_um_jogador.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'screen/login/inicio_dois_jogadores.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  	// Garante que o Flutter está inicializado
	await dotenv.load(fileName: ".env");
	
	WidgetsFlutterBinding.ensureInitialized();

	// Inicializa o sqflite para desktop
	if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
		// Define o caminho para a biblioteca SQLite
		sqfliteFfiInit();
		databaseFactory = databaseFactoryFfi;
	}

	runApp(
		MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (_) => QuestionsSyncProvider()),
			],
			child: MyApp(),
		)
	);
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			initialRoute: Routes.home,
			routes: {
				Routes.home:(context) => ModeGamePage() ,
				Routes.questoesDisponiveis: (context) => QuestionsDisponivel(),
				Routes.questionScreenUmJogador: (context) => RoletaScreenUmJogador(),
				Routes.questionScreenDoisJogador: (context) => RoletaScreenDoisJogador(),
				Routes.addQuestion: (context) => AddQuestionsScreen(),
				Routes.aboutScreen: (context) => AboutPage(),
				Routes.umJogador: (context) => InicioUmJogador(),
				Routes.doisJogador: (context) => InicioDoisJogadores(),
				Routes.loadingScreenUmJogador: (context) => LoadingGameUmJogador(),
				Routes.loadingScreenDoisJogador: (context) => LoadingGameDoisJogador(),
			},
			builder: (context, child) {
				Future.microtask(() async {
					if (context.mounted) {
						await Provider.of<QuestionsSyncProvider>(context, listen: false).connect();
						if (context.mounted) {
							await Provider.of<QuestionsSyncProvider>(context, listen: false).syncAllQuestionsDatabaseToLocal(context);
						}
					}
				});
				return child!;
			},
		);
	}
}