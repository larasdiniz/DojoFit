import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/core/network/network_logger.dart';
import 'package:dojofit/features/exercises/data/datasources/exercises_datasource.dart';
import 'package:dojofit/features/exercises/data/repositories/exercises_repository_impl.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pop_network/pop_network.dart';

class MockExercisesDatasource extends Mock implements ExercisesDatasource {}

class TestNetworkLogger extends NetworkLogger {
  TestNetworkLogger() {
    logPrint = (Object object) {};
  }
}

void main() {
  late ExercisesRepositoryImpl repository;
  late MockExercisesDatasource dataSource;
  late TestNetworkLogger logger;

  final tApiResultSuccess = Response(
    requestOptions: RequestOptions(path: ''),
    data: [
      {
        'name': 'Biceps Curl',
        'type': 'strength',
        'muscle': 'biceps',
        'difficulty': 'beginner',
        'equipments': ['dumbbell'],
        'instructions': 'Stand up straight...',
      },
    ],
    statusCode: 200,
  );

  final tApiResultError = Response(
    requestOptions: RequestOptions(path: ''),
    data: 'Erro no servidor',
    statusCode: 400,
  );

  setUp(() {
    FlutterError.onError = (FlutterErrorDetails details) {};
    dataSource = MockExercisesDatasource();
    logger = TestNetworkLogger();

    repository = ExercisesRepositoryImpl(
      datasource: dataSource,
      logger: logger,
    );
  });

  tearDown(() {
    FlutterError.onError = FlutterError.dumpErrorToConsole;
  });

  group('ExercisesRepositoryImpl', () {
    test(
      'Deve retornar uma lista de ExerciseEntity ao receber status 200',
      () async {
        // arrange
        when(
          () => dataSource.getExercises(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenAnswer((_) async => tApiResultSuccess);

        // act
        final result = await repository.getExercises();

        // assert
        expect(result, isA<Right<Failure, List<ExerciseEntity>>>());
        result.fold((l) => fail('Deveria retornar sucesso'), (r) {
          expect(r.first.name, 'Biceps Curl');
          expect(r, isA<List<ExerciseEntity>>());
        });
      },
    );

    test('Deve retornar ServerFailure ao receber status 400 da API', () async {
      // arrange
      when(
        () => dataSource.getExercises(
          name: any(named: 'name'),
          type: any(named: 'type'),
          muscle: any(named: 'muscle'),
          difficulty: any(named: 'difficulty'),
          equipments: any(named: 'equipments'),
        ),
      ).thenAnswer((_) async => tApiResultError);

      // act
      final result = await repository.getExercises();

      // assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('400'));
      }, (success) => fail('Deveria ter retornado um erro'));
    });

    test(
      'Deve retornar um InternalFailure quando o mapeamento do model falhar (JSON malformatado)',
      () async {
        // arrange
        final tApiResultInvalidData = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'campo_errado': 'isso deveria ser uma lista, mas é um map'},
          statusCode: 200,
        );

        when(
          () => dataSource.getExercises(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenAnswer((_) async => tApiResultInvalidData);

        // act
        final result = await repository.getExercises();

        // assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<InternalFailure>());
          expect(
            failure.message,
            contains('erro interno ao processar os dados'),
          );
        }, (_) => fail('Deveria retornar um Left do tipo InternalFailure'));
      },
    );

    test(
      'Deve retornar NetworkFailure quando a API responder com status nulo (Falta de conexão física)',
      () async {
        // arrange
        final tNoConnectionResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: 'No internet connection',
          statusCode: null,
        );

        when(
          () => dataSource.getExercises(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenAnswer((_) async => tNoConnectionResponse);

        // act
        final result = await repository.getExercises();

        // assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, contains('Sem conexão com a internet'));
        }, (_) => fail('Deveria retornar um NetworkFailure'));
      },
    );

    test(
      'Deve retornar NetworkFailure quando o datasource estourar uma exceção nativa de timeout do Dart',
      () async {
        // arrange
        when(
          () => dataSource.getExercises(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenThrow(Exception('Connection timeout'));

        // act
        final result = await repository.getExercises();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Deveria retornar um NetworkFailure'),
        );
      },
    );
  });
}
