import 'package:dojofit/features/exercises/data/datasources/exercises_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pop_network/pop_network.dart';

class IApiManagerMock extends Mock implements IApiManager {}

void main() {
  late IApiManager apiManagerMock;
  late ExercisesDatasource dataSource;

  setUp(() {
    apiManagerMock = IApiManagerMock();
    dataSource = ExercisesDatasource(apiManagerMock);
    registerFallbackValue(const MockReplyParams(mockPath: ''));
  });

  final tResponse = Response(
    data: [],
    statusCode: 200,
    requestOptions: RequestOptions(path: '/v1/exercises'),
  );

  group('ExercisesDatasource', () {
    test(
      'deve retornar um Response de sucesso quando o ApiManager responder com status 200',
      () async {
        // ARRANGE
        when(
          () => apiManagerMock.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            mockReplyParams: any(named: 'mockReplyParams'),
          ),
        ).thenAnswer((_) async => tResponse);

        // ACT
        final result = await dataSource.getExercises();

        // ASSERT
        expect(result, equals(tResponse));
        expect(result.statusCode, 200);
      },
    );

    test(
      'deve repassar o erro 400 quando o ApiManager retornar falha na requisição',
      () async {
        // ARRANGE
        final tErrorResponse = Response(
          data: {'error': 'Invalid parameters'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/v1/exercises'),
        );

        when(
          () => apiManagerMock.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            mockReplyParams: any(named: 'mockReplyParams'),
          ),
        ).thenAnswer((_) async => tErrorResponse);

        // ACT
        final result = await dataSource.getExercises(name: 'erro');

        // ASSERT
        expect(result.statusCode, 400);
      },
    );
  });

  group('ExercisesDatasourceMock', () {
    test(
      'deve solicitar o mockPath "exercises_search_chest_mock" quando filtrar pelo músculo "chest"',
      () async {
        // ARRANGE
        when(
          () => apiManagerMock.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            mockReplyParams: any(named: 'mockReplyParams'),
          ),
        ).thenAnswer((_) async => tResponse);

        // ACT
        await dataSource.getExercises(muscle: 'chest');

        final captured =
            verify(
                  () => apiManagerMock.get(
                    any(),
                    queryParameters: any(named: 'queryParameters'),
                    mockReplyParams: captureAny(named: 'mockReplyParams'),
                  ),
                ).captured.last
                as MockReplyParams;

        expect(captured.mockPath, equals('exercises_search_chest_mock'));
      },
    );

    test(
      'deve solicitar o mockPath "get_exercises_empty" quando o nome da busca for "vazio"',
      () async {
        // ARRANGE
        when(
          () => apiManagerMock.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            mockReplyParams: any(named: 'mockReplyParams'),
          ),
        ).thenAnswer((_) async => tResponse);

        // ACT
        await dataSource.getExercises(name: 'vazio');

        // ASSERT
        final captured =
            verify(
                  () => apiManagerMock.get(
                    any(),
                    queryParameters: any(named: 'queryParameters'),
                    mockReplyParams: captureAny(named: 'mockReplyParams'),
                  ),
                ).captured.last
                as MockReplyParams;

        expect(captured.mockPath, equals('get_exercises_empty'));
      },
    );

    test(
      'deve retornar o mockPath padrão "exercises_list_mock" quando nenhum parâmetro específico for enviado',
      () async {
        // ARRANGE
        when(
          () => apiManagerMock.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            mockReplyParams: any(named: 'mockReplyParams'),
          ),
        ).thenAnswer((_) async => tResponse);

        // ACT
        await dataSource.getExercises();

        // ASSERT
        final captured =
            verify(
                  () => apiManagerMock.get(
                    any(),
                    queryParameters: any(named: 'queryParameters'),
                    mockReplyParams: captureAny(named: 'mockReplyParams'),
                  ),
                ).captured.last
                as MockReplyParams;

        expect(captured.mockPath, equals('exercises_list_mock'));
      },
    );
  });
}
