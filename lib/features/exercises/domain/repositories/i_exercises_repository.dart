import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/exercise_entity.dart';

abstract class IExercisesRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  });
}
