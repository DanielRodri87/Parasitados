import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/provider/questions_sync_provider.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:provider/provider.dart';

class QuestionsDisponivel extends StatelessWidget {
	const QuestionsDisponivel({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
				floatingActionButton: FloatingActionButton(
					onPressed: () {
						Navigator.pushNamed(context, Routes.addQuestion);
					},
					backgroundColor: const Color(0xFF00DB8F),
					child: const Icon(Icons.add, color: Colors.white),
				),
				  body: Material(
					child: Consumer<QuestionsSyncProvider>(
						builder: (context, questionsProvider, child) {
							final questoes = questionsProvider.allQuestions;
							if (questoes.isEmpty) {
								return const Center(child: Text('Nenhuma questão disponível.'));
							}
							return ListView(
								shrinkWrap: true,
								children: questoes.entries.map((entry) {
									final q = entry.value;
									return Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(q.enunciado),
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: q.opcoes.map<Widget>((alt) {
												final letra = alt.keys.first;
												final texto = alt.values.first;
												final isCorreta = Question.parseRespostaCorreta(letra) == q.respostaCorreta;
												return Padding(
													padding: const EdgeInsets.symmetric(vertical: 2.0),
													child: Row(
													children: [
														Text(
														'$letra) ',
														style: TextStyle(
															fontWeight: FontWeight.bold,
															color: isCorreta ? Colors.green : null,
														),
														),
														Expanded(
														child: Text(
															texto,
															style: TextStyle(
															color: isCorreta ? Colors.green : null,
															),
														),
														),
													],
													),
												);
												}).toList(),
											)
										],
									);
								}).toList(),
							);
						},
					),
				  ),
				);
	}
}