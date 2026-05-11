import 'package:dojofit/features/exercises/data/datasources/exercises_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pop_network/pop_network.dart';

// 1. Definição do Mock
class IApiManagerMock extends Mock implements IApiManager {}

void main() {
  late IApiManager apiManager;
  late ExercisesDatasource dataSource;

  // 2. Resposta de sucesso simulada
  final tResponse = Response(
    data: [
      {'name': 'Push up'},
    ],
    statusCode: 200,
    requestOptions: RequestOptions(path: ''),
  );

  setUp(() {
    apiManager = IApiManagerMock();
    dataSource = ExercisesDatasource(apiManager);
  });

  group('ExercisesDatasource', () {
    test(
      'Deve retornar um Response quando a chamada ao API Manager for bem sucedida',
      () async {
        // ARRANGE
        // O segredo para não dar erro de Null:
        // Use any() para a String do path e any(named: ...) para o Map de queryParameters.
        when(
          () => apiManager.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // ACT
        final result = await dataSource.getExercises(muscle: 'chest');

        // ASSERT
        expect(result, isA<Response>());
        expect(result.statusCode, 200);

        // Verifica se o datasource enviou o path correto para a PopNetwork
        verify(
          () => apiManager.get(
            '/v1/exercises',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test('Deve repassar o erro quando o API Manager falhar', () async {
      // ARRANGE
      final tErrorResponse = Response(
        data: 'Erro',
        statusCode: 400,
        requestOptions: RequestOptions(path: ''),
      );

      when(
        () => apiManager.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => tErrorResponse);

      // ACT
      final result = await dataSource.getExercises();

      // ASSERT
      expect(result.statusCode, 400);
    });
  });
}
