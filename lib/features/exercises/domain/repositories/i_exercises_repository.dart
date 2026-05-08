import 'package:dartz/dartz.dart';
import 'package:dojofit/core/error/failures.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';

abstract class IExercisesRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  });
}
