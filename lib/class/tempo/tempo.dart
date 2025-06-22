class Tempo {
  static DateTime converteSegundosTempo(double seconds) {
    int tempo = seconds.ceil();

    int horas = tempo ~/ 3600;
    int minutos = (tempo % 3600) ~/ 60;
    int segundos = tempo % 60;

    return DateTime(0, 1, 1, horas, minutos, segundos);
  }
}
