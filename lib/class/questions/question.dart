class Question {
	final int? id;
	final String enunciado;
	final String topico;
	final int respostaCorreta;
	final List<String> opcoes;

	Question({
		this.id,
		required this.enunciado,
		required this.topico,
		required this.opcoes,
		required this.respostaCorreta,
	});

	factory Question.fromJson(int id, Map<String, dynamic> json) {
		return Question(
			id: json["id"] ?? id, // ou ajuste conforme necessário
			topico: json["topico"] ?? json["capitulo"] ?? '',
			enunciado: json["pergunta"] ?? json["enunciado"] ?? '',
			opcoes: json["alternativas"] ?? json["opcoes"] ?? [],
			respostaCorreta: parseRespostaCorreta(json["resposta"]),
		);
	}

	static int parseRespostaCorreta(dynamic resposta) {
		if (resposta is String && resposta.isNotEmpty) {
			return resposta.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1;
		}
		if (resposta is int) return resposta;
		return 0;
	}

	static String parseRespostaString(int resposta) {
		if (resposta >= 1 && resposta <= 5) {
			return String.fromCharCode('a'.codeUnitAt(0) + resposta - 1);
		}
		return '';
	}

	Map<String, dynamic> toJson() {
    return {
      'topico': topico,
      'pergunta': enunciado,
      'alternativas': opcoes,
      'resposta': parseRespostaString(respostaCorreta),
    };
  }
}