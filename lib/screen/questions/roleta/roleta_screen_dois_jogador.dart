import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/screen/questions/roleta/roleta_screen.dart';

class RoletaScreenDoisJogador extends StatelessWidget {
  const RoletaScreenDoisJogador({super.key});

  @override
  Widget build(BuildContext context) {
    return RoletaScreen(
		modeGame: TypeModeGame.doisJogador
	);
  }
}