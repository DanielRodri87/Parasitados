import 'package:flutter/material.dart';
import 'package:parasitados/routes/routes.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
	double progress = 0.0;

	@override
	void initState() {
		super.initState();
		// Simula o carregamento
		Future.delayed(const Duration(milliseconds: 500), _startLoading);
	}

	void _startLoading() async {
		for (int i = 1; i <= 100; i++) {
		await Future.delayed(const Duration(milliseconds: 25));
			setState(() {
				progress = i / 100;
			});
		}

		if(mounted) Navigator.pushReplacementNamed(context, Routes.home);
	}

	@override
	Widget build(BuildContext context) {
		final size = MediaQuery.of(context).size;
		final isSmall = size.width < 350;
		final fontSize = isSmall ? 50.0 : 56.0;

		return Scaffold(
			body: Container(
				decoration: const BoxDecoration(
					image: DecorationImage(
						image: AssetImage("assets/splash/loading_splash.png"),
						fit: BoxFit.cover,
					),
				),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Text(
							"Parasitados",
							style: TextStyle(
								fontFamily: "Luckiest_Guy",
								fontSize: fontSize,
								color: Color(0xffF8B221),
							),
						),
						Stack(
							alignment: Alignment.center,
							children: [
								LinearProgressIndicator(
									value: progress,
									backgroundColor: Colors.black,
									valueColor: const AlwaysStoppedAnimation(Colors.blue),
									borderRadius: BorderRadius.circular(5),
									minHeight: 24,
								),
								Text(
									"${(progress * 100).toInt()}%",
									style: const TextStyle(
										color: Colors.white,
										fontWeight: FontWeight.bold,
										fontSize: 16,
									),
									textAlign: TextAlign.center,
								),
							],
						),
					],
				),
			),
		);
	}
}