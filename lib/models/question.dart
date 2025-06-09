class Question {
  final int id;
  final String enunciado;
  final String opcaoA;
  final String opcaoB;
  final String opcaoC;
  final String opcaoD;
  final int respostaCorreta;

  Question({
    required this.id,
    required this.enunciado,
    required this.opcaoA,
    required this.opcaoB,
    required this.opcaoC,
    required this.opcaoD,
    required this.respostaCorreta,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      enunciado: map['enunciado'],
      opcaoA: map['opcao_a'],
      opcaoB: map['opcao_b'],
      opcaoC: map['opcao_c'],
      opcaoD: map['opcao_d'],
      respostaCorreta: map['resposta_correta'],
    );
  }
}
