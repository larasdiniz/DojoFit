abstract class Failure {
  final String message;
  Failure(this.message);
}

// Erro para quando a API falhar
class ServerFailure extends Failure {
  ServerFailure(super.message);
}

// Erro para quando a internet cair
class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

// Erro para quando o app flahar ao processar o dado da API
class InternalFailure extends Failure {
  InternalFailure(super.message);
}
