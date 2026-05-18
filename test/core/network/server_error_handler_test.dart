import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/core/network/server_error_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pop_network/pop_network.dart';

void main() {
  group('ServerErrorHandler', () {
    test(
      'Deve retornar ServerFailure com mensagem de "Requisição inválida" quando o status for 400',
      () {
        // Arrange
        final response = Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = ServerErrorHandler.handle(response);

        // Assert
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Requisição inválida (400)'));
      },
    );

    test(
      'Deve retornar ServerFailure com mensagem de "Não autorizado" quando o status for 403',
      () {
        // Arrange
        final response = Response(
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = ServerErrorHandler.handle(response);

        // Assert
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Não autorizado (403)'));
      },
    );

    test(
      'Deve retornar ServerFailure com mensagem de "Serviço não encontrado" quando o status for 404',
      () {
        // Arrange
        final response = Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = ServerErrorHandler.handle(response);

        // Assert
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Serviço não encontrado (404)'));
      },
    );

    test(
      'Deve retornar ServerFailure com mensagem de "Muitas requisições" quando o status for 429',
      () {
        // Arrange
        final response = Response(
          statusCode: 429,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = ServerErrorHandler.handle(response);

        // Assert
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Muitas requisições (429)'));
      },
    );

    test(
      'Deve retornar ServerFailure com mensagem de erro 500 quando o status code for 500',
      () {
        // Arrange
        final response = Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        );

        // Act
        final result = ServerErrorHandler.handle(response);

        // Assert
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Erro interno no servidor (500)'));
      },
    );
  });
}
