import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/i_exercises_repository.dart';
import '../datasources/exercises_datasource.dart';
import '../models/exercise_model.dart';

class ExercisesRepositoryImpl implements IExercisesRepository {
  final ExercisesDatasource _datasource;

  ExercisesRepositoryImpl({required ExercisesDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  }) async {
    final result = await _datasource.getExercises(
      name: name,
      type: type,
      muscle: muscle,
      difficulty: difficulty,
      equipments: equipments,
    );
    try {
      if (result.statusCode == 200) {
        final List<dynamic> data = result.data;
        final list = data
            .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return Right(list);
      }
      return Left(ServerFailure('Erro na API: ${result.statusCode}'));
    } catch (e) {
      return Left(ServerFailure('Falha ao processar dados: $e'));
    }
  }
}
