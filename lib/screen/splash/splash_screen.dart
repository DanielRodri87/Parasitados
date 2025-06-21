import 'package:flutter/material.dart';

void main(){
	runApp(
		MaterialApp(
			home: SplashScreen(),
		) );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		body: Container(
			decoration: BoxDecoration(
				image: DecorationImage(
					image: AssetImage("assets/splash/loading_splash.png"),
					fit: BoxFit.cover
				)
			),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(
						"Parasitados",
						style: TextStyle(
							fontFamily: "Luckiest_Guy",
							fontSize: 60,
							color: Color(0xffF8B221)
						),
					),
					LinearProgressIndicator(
						backgroundColor: Colors.black,
						valueColor:AlwaysStoppedAnimation(
							Colors.blue
						),
					)
				],
			),
		),
	);
  }
}