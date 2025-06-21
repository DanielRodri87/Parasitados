import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/screen/questions/partials/loading/loading_game.dart';

class LoadingGameUmJogador extends StatelessWidget {
  const LoadingGameUmJogador({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingGamePage(
		tipoModeGame: TypeModeGame.umJogador,
	);
  }
}