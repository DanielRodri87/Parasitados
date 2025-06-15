class Question {
  final int id;
  final String enunciado;
  final int respostaCorreta;
  final List opcoes;

  Question({
    required this.id,
    required this.enunciado,
    required this.opcoes,
    required this.respostaCorreta,
  });

  factory Question.fromJson(int id, Map<String, dynamic> json) {
    return Question(
      id: json["id"] ?? id, // ou ajuste conforme necessário
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

  Map<String, dynamic> toJson() {
    // Converte respostaCorreta para letra (a, b, c, d) se necessário
    String respostaLetra = respostaCorreta > 0
        ? String.fromCharCode('a'.codeUnitAt(0) + respostaCorreta - 1)
        : respostaCorreta.toString();
    return {
      'pergunta': enunciado,
      'resposta': respostaLetra,
      'alternativas': opcoes,
    };
  }
}