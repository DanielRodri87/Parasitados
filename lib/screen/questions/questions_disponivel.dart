import 'package:flutter/material.dart';
import 'package:parasitados/class/questions/question.dart';
import 'package:parasitados/class/questions/questions.dart';

class QuestionsDisponivel extends StatelessWidget {
  const QuestionsDisponivel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<Questions>(
        future: Questions.fromJsonFile('assets/pdf/questions.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar questões: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.questoes.isEmpty) {
            return const Center(child: Text('Nenhuma questão disponível.'));
          }
          final questoes = snapshot.data!.questoes;
          return ListView(
            shrinkWrap: true,
            children: questoes.entries.map((entry) {
              final q = entry.value;
              return Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						q.enunciado
					),
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
    );
  }
}