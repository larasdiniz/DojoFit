import 'package:dartz/dartz.dart';
import 'package:dojofit/core/network/server_error_handler.dart';
import 'package:dojofit/core/network/network_logger.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/i_exercises_repository.dart';
import '../datasources/exercises_datasource.dart';
import '../models/exercise_model.dart';

class ExercisesRepositoryImpl implements IExercisesRepository {
  final ExercisesDatasource _datasource;
  final NetworkLogger _logger;

  ExercisesRepositoryImpl({
    required ExercisesDatasource datasource,
    required NetworkLogger logger,
  }) : _datasource = datasource,
       _logger = logger;

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
        final List<dynamic> data = result.data ?? [];
        final list = data.map((e) => ExerciseModel.fromJson(e)).toList();
        return Right(list);
      }
      return Left(ServerErrorHandler.handle(result));
    } catch (e, stackTrace) {
      _logger.logPrint('Erro ao processar Exercise: $e');
      _logger.logPrint('Stacktrace: $stackTrace');
    }
    return Left(
      ServerFailure('Ocorreu um erro inesperado ao carregar os exercícios'),
    );
  }
}
