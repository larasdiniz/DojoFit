import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:dojofit/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:dojofit/features/exercises/presentation/cubit/exercises_cubit.dart';
import 'package:dojofit/features/exercises/presentation/cubit/exercises_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExercisesUseCase extends Mock implements GetExercisesUseCase {}

void main() {
  late ExercisesCubit cubit;
  late MockGetExercisesUseCase getExercisesUseCase;

  const tExercisesList = [
    ExerciseEntity(
      name: 'Biceps Curl',
      type: 'strength',
      muscle: 'biceps',
      difficulty: 'beginner',
      equipments: ['dumbbell'],
    ),
  ];

  setUp(() {
    getExercisesUseCase = MockGetExercisesUseCase();
    cubit = ExercisesCubit(getExercisesUseCase: getExercisesUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('O estado inicial deve ser ExercisesInitial', () {
    // assert
    expect(cubit.state, isA<ExercisesInitial>());
  });

  group('Carregar Exercicios', () {
    blocTest<ExercisesCubit, ExercisesState>(
      'Deve emitir ExercisesLoading e ExercisesSuccess ao buscar exercicios com sucesso',
      build: () {
        // arrange
        when(
          () => getExercisesUseCase(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenAnswer((_) async => const Right(tExercisesList));
        return cubit;
      },
      act: (cubit) {
        // act
        cubit.loadExercises(muscle: 'biceps');
      },
      expect: () => <dynamic>[
        // assert
        isA<ExercisesLoading>(),
        isA<ExercisesSuccess>(),
      ],
    );

    blocTest<ExercisesCubit, ExercisesState>(
      'Deve emitir ExercisesLoading e ExercisesError quando o usecase retornar uma falha',
      build: () {
        // arrange
        when(
          () => getExercisesUseCase(
            name: any(named: 'name'),
            type: any(named: 'type'),
            muscle: any(named: 'muscle'),
            difficulty: any(named: 'difficulty'),
            equipments: any(named: 'equipments'),
          ),
        ).thenAnswer(
          (_) async => Left(ServerFailure('Erro no servidor (400)')),
        );
        return cubit;
      },
      act: (cubit) {
        // act
        cubit.loadExercises(muscle: 'biceps');
      },
      expect: () => <dynamic>[
        // assert
        isA<ExercisesLoading>(),
        isA<ExercisesError>(),
      ],
    );
  });
}
