import 'package:flutter/material.dart';
import 'package:parasitados/provider/questions_sync_provider.dart';
import 'package:parasitados/provider/ranking_provider.dart';
import 'package:parasitados/screen/about/about.dart';
import 'package:parasitados/screen/login/inicio_um_jogador.dart';
import 'package:parasitados/screen/login/mode_game.dart';
import 'package:parasitados/screen/questions/add_questions.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/questions/partials/loading/loading_game_dois_jogador.dart';
import 'package:parasitados/screen/questions/partials/loading/loading_game_um_jogador.dart';
import 'package:parasitados/screen/questions/questions_disponivel.dart';
import 'package:parasitados/screen/questions/partials/roleta/roleta_screen_dois_jogador.dart';
import 'package:parasitados/screen/questions/partials/roleta/roleta_screen_um_jogador.dart';
import 'package:parasitados/screen/ranking/ranking.dart';
import 'package:parasitados/screen/splash/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'screen/login/inicio_dois_jogadores.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
	await dotenv.load(fileName: ".env");

	WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
	FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

	// Inicializa o sqflite para desktop
	if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
		// Define o caminho para a biblioteca SQLite
		sqfliteFfiInit();
		databaseFactory = databaseFactoryFfi;
	}

	// Aguarda o audio tocar e entra no app
	FlutterNativeSplash.remove();

	await Supabase.initialize(
		url: dotenv.env['PUBLIC_SUPABASE_URL'] ?? '',
		anonKey: dotenv.env['PUBLIC_SUPABASE_ANON_KEY'] ?? '',
	);

	runApp(
		MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (_) => QuestionsSyncProvider()),
				ChangeNotifierProvider(create: (_) => RankingProvider()),
			],
			child: MyApp(),
		),
	);
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			initialRoute: Routes.splashScreen,
			routes: {
				Routes.home: (context) => ModeGamePage(),
				Routes.splashScreen: (context) => SplashScreen(),
				Routes.questoesDisponiveis: (context) => QuestionsDisponivel(),
				Routes.questionScreenUmJogador: (context) => RoletaScreenUmJogador(),
				Routes.questionScreenDoisJogador: (context) => RoletaScreenDoisJogador(),
				Routes.addQuestion: (context) => AddQuestionsScreen(),
				Routes.aboutScreen: (context) => AboutPage(),
				Routes.umJogador: (context) => InicioUmJogador(),
				Routes.doisJogador: (context) => InicioDoisJogadores(),
				Routes.loadingScreenUmJogador: (context) => LoadingGameUmJogador(),
				Routes.loadingScreenDoisJogador: (context) => LoadingGameDoisJogador(),
				Routes.rankingScreen: (context) => RankingScreen(),
			},
			builder: (context, child) {
				Future.microtask(() async {
					if (context.mounted) {
						await Provider.of<QuestionsSyncProvider>(
							context,
							listen: false,
						).connect();
						if (context.mounted) {
							await Provider.of<QuestionsSyncProvider>(
								context,
								listen: false,
							).syncAllQuestionsDatabaseToLocal(context);
						}
					}
				});
				return child!;
			},
		);
	}
}
