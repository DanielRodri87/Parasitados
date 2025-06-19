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
											RichText(
												text: TextSpan(
													style: DefaultTextStyle.of(context).style,
													children: parseItalics(q.enunciado),
												),
											),
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: q.opcoes.asMap().entries.map<Widget>((entry) {
												final index = entry.key;
												final texto = entry.value;
												final letra = String.fromCharCode('a'.codeUnitAt(0) + index); // 65 is 'A'
												final isCorreta = Question.parseRespostaCorreta(letra) == q.respostaCorreta;
												
												return Padding(
													padding: const EdgeInsets.symmetric(vertical: 2.0),
													child: Row(
													children: [
														Text(
														'$letra) ',
															style: TextStyle(
																fontWeight: FontWeight.bold,
																color: isCorreta ? Colors.green : Colors.black,
															),
														),
														Expanded(
														child: RichText(
															text: TextSpan(
																style: TextStyle(
																	color: isCorreta ? Colors.green : Colors.black,
																),
																children: parseItalics(texto),
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

// Função utilitária para aplicar itálico entre *texto*
List<InlineSpan> parseItalics(String text, {TextStyle? style, TextStyle? italicStyle}) {
  final spans = <InlineSpan>[];
  final regex = RegExp(r'\*(.*?)\*');
  int start = 0;
  final normal = style ?? const TextStyle();
  final italic = italicStyle ?? const TextStyle(fontStyle: FontStyle.italic);
  for (final match in regex.allMatches(text)) {
    if (match.start > start) {
      spans.add(TextSpan(text: text.substring(start, match.start), style: normal));
    }
    spans.add(TextSpan(text: match.group(1), style: italic));
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: normal));
  }
  return spans;
}