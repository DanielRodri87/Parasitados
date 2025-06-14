import 'package:flutter/material.dart';
import 'package:parasitados/provider/questions_sync_provider.dart';
import 'package:parasitados/screen/about/about.dart';
import 'package:parasitados/screen/questions/add_questions.dart';
import 'package:parasitados/screen/questions/home.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/questions/loading_game.dart';
import 'package:parasitados/screen/questions/questions_disponivel.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'screen/login/login_page.dart';
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
				Routes.home:(context) => LoginPage() ,
				Routes.questoesDisponiveis: (context) => QuestionsDisponivel(),
				Routes.questionScreen: (context) => HomePage(),
				Routes.addQuestion: (context) => AddQuestionsScreen(),
				Routes.aboutScreen: (context) => AboutPage(),
				Routes.loadingScreen: (context) => LoadingGamePage(),
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