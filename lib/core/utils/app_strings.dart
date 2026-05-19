enum AppStrings {
  tituloApp('DojoFit - Exercícios'),
  nenhumExercicio('Nenhum exercício encontrado.'),
  tentarNovamente('Tentar Novamente'),
  loading('Carregando exercícios...');

  // Construtor do enum que recebe o texto correspondente
  const AppStrings(this.texto);
  final String texto;

  // Função estática para quando precisamos injetar variáveis no meio do texto
  static String infoExercicio({
    required String muscle,
    required String difficulty,
  }) {
    return 'Músculo: $muscle | Dificuldade: $difficulty';
  }
}
