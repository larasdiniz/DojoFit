import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:dojofit/features/exercises/domain/repositories/i_exercises_repository.dart';
import 'package:dojofit/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExercisesRepository extends Mock implements IExercisesRepository {}

void main() {
  late MockExercisesRepository mockExercisesRepository;
  late GetExercisesUseCase getExercisesUseCase;

  const tExerciseEntity = ExerciseEntity(
    name: 'Push up',
    type: 'strength',
    muscle: 'chest',
    difficulty: 'beginner',
    equipments: ['body_only'],
  );

  setUp(() {
    mockExercisesRepository = MockExercisesRepository();
    getExercisesUseCase = GetExercisesUseCase(
      repository: mockExercisesRepository,
    );
  });

  group('Get exercises', () {
    test(
      'Deve retornar uma lista de ExerciseEntity quando obter um sucesso',
      () async {
        // arrange
        when(
          () => mockExercisesRepository.getExercises(
            muscle: any(named: 'muscle'),
          ),
        ).thenAnswer((_) async => const Right([tExerciseEntity]));
        // act
        final result = await getExercisesUseCase(muscle: 'chest');
        // assert
        expect(
          result,
          equals(const Right<Failure, List<ExerciseEntity>>([tExerciseEntity])),
        );
      },
    );

    test('Deve retornar um ServerFailure quando a API falhar', () async {
      // arrange
      when(
        () =>
            mockExercisesRepository.getExercises(muscle: any(named: 'muscle')),
      ).thenAnswer((_) async => Left(ServerFailure('Erro no servidor')));
      // act
      final result = await getExercisesUseCase(muscle: 'chest');
      // assert
      expect(result.isLeft(), true);
      result.fold(
        (left) => expect(left, isA<ServerFailure>()),
        (right) => fail('Esperava-se um Left, mas recebeu um Right'),
      );
    });
  });
}
