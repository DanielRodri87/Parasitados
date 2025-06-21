import 'package:flutter/material.dart';
import 'package:parasitados/class/tempo/tempo.dart';
import 'package:parasitados/provider/ranking_provider.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/ranking/partials/arc_text_painter.dart';
import 'package:parasitados/screen/ranking/partials/metric_card.dart';

import 'package:provider/provider.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  Future<void> _loadRanking(BuildContext context) async {
    await Provider.of<RankingProvider>(context, listen: false).getRankingPorId();
  }

  @override
  Widget build(BuildContext context) {
    final future = _loadRanking(context);

    return FutureBuilder(
      future: future,
      builder: (context, asyncSnapshot) {
        return Consumer<RankingProvider>(
          builder: (context, value, child) {
            final tempoRealizadoRaw = value.ranking?['tempo_realizado'] ?? 0.0;
            final tempoRealizado = tempoRealizadoRaw is int
                ? tempoRealizadoRaw.toDouble()
                : (tempoRealizadoRaw as double);
            DateTime tempo = Tempo.converteSegundosTempo(tempoRealizado);

            return Scaffold(
						body: Stack(
						children: [
							// Fundo
							Positioned.fill(
							child: Image.asset(
								'assets/images/backRanking.png',
								fit: BoxFit.cover,
							),
							),
							SafeArea(
								child: Column(
								children: [
									const SizedBox(height: 16),
									Padding(
										padding: EdgeInsetsGeometry.only(left: 10,right: 10),
									child: Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												IconButton(
													onPressed: (){
														Navigator.pushReplacementNamed(context,Routes.home);
													}, 
													icon: Icon(
														Icons.arrow_back_outlined,
														color: Colors.white,
													)
												),
												Text(
													'Parasitados',
													style: TextStyle(
													fontSize: 20,
													fontWeight: FontWeight.bold,
													color: Colors.white,
													fontFamily: 'Georgia',
													),
												),
											],
										),
										Text(
											'Descubra seus dons conosco!',
											style: TextStyle(
												fontSize: 14,
												color: Colors.white,
												fontFamily: 'Georgia',
											),
											textAlign: TextAlign.center,
										),
									],
																),
								),
								const SizedBox(height: 16),
								// Pulga
								Image.asset(
									'assets/images/pulgo.png',
									height: 200,
								),
								const SizedBox(height: 16),
								// LadoPar e Texto
								SizedBox(
									height: 80,
									child: CustomPaint(
									painter: ArcTextPainter(
										text: 'LADOPAR',
										textStyle: const TextStyle(
										fontSize: 42,
										fontWeight: FontWeight.bold,
										color: Colors.white,
										fontFamily: 'Shrikhand',
										letterSpacing: 2,
										),
									),
									size: const Size(300, 80),
									),
								),
								const SizedBox(height: 8),
								if(value.ranking == null)
									Text(
										"Jogue primeiro!"
									)
									else
									...[
										Text(
											'Você ficou no top ${value.posicao ?? "-"} no\nParasitados',
											textAlign: TextAlign.center,
											style: TextStyle(
												fontSize: 16,
												color: Colors.black87,
												fontWeight: FontWeight.w500,
												fontFamily: 'YoungSerif',
											),
										),
										const SizedBox(height: 24),
										const Spacer(), // Adiciona um spacer para empurrar os cards para baixo
										// Cartões de métricas
										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 24.0),
											child: Wrap(
												spacing: 16,
												runSpacing: 16,
												children: [
													MetricCard(
														icon: 'assets/images/rankingrank.png',
														label: 'Top ${value.posicao ?? "-"}',
														sublabel: 'Rank',
													),
													MetricCard(
														icon: 'assets/images/pontorank.png',
														label: '${((value.ranking?['taxa_de_acerto'] ?? 0.0) is int ? (value.ranking?['taxa_de_acerto'] ?? 0.0).toDouble() : (value.ranking?['taxa_de_acerto'] ?? 0.0)).toStringAsFixed(0)}%',
														sublabel: 'Taxa de acertos',
													),
													MetricCard(
														icon: 'assets/images/raiorank.png',
														label: '${value.ranking?['qtd_acertos']} Acertos',
														sublabel: 'Desempenho',
													),
													MetricCard(
														icon: 'assets/images/relogiorank.png',
														label: tempo.hour > 0
															? '${tempo.hour.toString().padLeft(2, '0')}:${tempo.minute.toString().padLeft(2, '0')}:${tempo.second.toString().padLeft(2, '0')} h'
															: tempo.minute > 0
																? '${tempo.minute.toString().padLeft(2, '0')}:${tempo.second.toString().padLeft(2, '0')} min'
																: '${tempo.second.toString().padLeft(2, '0')} s',
														sublabel: 'Tempo Jogado',
													),
												],
											),
										),
									],
									SizedBox(height: 16,)
								],
							),
							),
						],
						),
				);
          }
        );
      }
    );
  }
}


