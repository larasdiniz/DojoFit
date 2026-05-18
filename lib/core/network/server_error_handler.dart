import '../error/failures.dart';
import 'package:pop_network/pop_network.dart';

class ServerErrorHandler {
  static Failure handle(Response response) {
    switch (response.statusCode) {
      case 400:
        return ServerFailure('Requisição inválida (400)');
      case 403:
        return ServerFailure('Não autorizado (403)');
      case 404:
        return ServerFailure('Serviço não encontrado (404)');
      case 429:
        return ServerFailure('Muitas requisições (429)');
      case 500:
        return ServerFailure('Erro interno no servidor (500)');
      default:
        return ServerFailure('Erro inesperado: ${response.statusCode}');
    }
  }
}
