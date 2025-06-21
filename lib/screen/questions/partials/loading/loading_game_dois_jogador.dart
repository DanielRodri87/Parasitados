import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/screen/questions/partials/loading/loading_game.dart';

class LoadingGameDoisJogador extends StatelessWidget {
  const LoadingGameDoisJogador({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingGamePage(
		tipoModeGame: TypeModeGame.doisJogador,
	);
  }
}
