import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/features/exercises/data/datasources/exercises_datasource.dart';
import 'package:dojofit/features/exercises/data/repositories/exercises_repository_impl.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pop_network/pop_network.dart';

// 1. Criamos o Mock do Datasource
class MockExercisesDatasource extends Mock implements ExercisesDatasource {}

void main() {
  late ExercisesRepositoryImpl repository;
  late MockExercisesDatasource dataSource;

  // 2. Preparamos os objetos de resposta (Mocks de Dados)
  final tApiResultSuccess = Response(
    requestOptions: RequestOptions(path: ''),
    data: [
      {
        'name': 'Biceps Curl',
        'type': 'strength',
        'muscle': 'biceps',
        'difficulty': 'beginner',
        'equipment': 'dumbbell',
        'instructions': 'Stand up straight...',
      },
    ],
    statusCode: 200,
  );

  // Simulando um erro de servidor (ex: 400)
  final tApiResultError = Response(
    requestOptions: RequestOptions(path: ''),
    data: 'Erro no servidor',
    statusCode: 400,
  );

  setUp(() {
    // Silencia erros de Flutter durante o teste (como no padrão Banese)
    FlutterError.onError = (FlutterErrorDetails details) {};
    dataSource = MockExercisesDatasource();
    repository = ExercisesRepositoryImpl(datasource: dataSource);
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
  });
}
