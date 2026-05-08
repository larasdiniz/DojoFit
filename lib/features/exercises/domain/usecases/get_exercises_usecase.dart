import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:dojofit/features/exercises/domain/repositories/i_exercises_repository.dart';

class GetExercisesUseCase {
  GetExercisesUseCase({required IExercisesRepository repository})
    : _repository = repository;

  final IExercisesRepository _repository;

  Future<Either<Failure, List<ExerciseEntity>>> call({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  }) => _repository.getExercises(
    name: name,
    type: type,
    muscle: muscle,
    difficulty: difficulty,
    equipments: equipments,
  );
}
