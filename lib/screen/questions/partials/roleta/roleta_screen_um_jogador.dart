import 'package:flutter/material.dart';
import 'package:parasitados/class/mode_game/mode_game.dart';
import 'package:parasitados/screen/questions/partials/roleta/roleta_screen.dart';

class RoletaScreenUmJogador extends StatelessWidget {
  const RoletaScreenUmJogador({super.key});

  @override
  Widget build(BuildContext context) {
    return RoletaScreen(modeGame: TypeModeGame.umJogador);
  }
}
