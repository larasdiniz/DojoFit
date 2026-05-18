import 'package:dartz/dartz.dart';
import '../../../../core/network/server_error_handler.dart';
import '../../../../core/network/network_logger.dart';
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
    try {
      final result = await _datasource.getExercises(
        name: name,
        type: type,
        muscle: muscle,
        difficulty: difficulty,
        equipments: equipments,
      );

      if (result.statusCode == 200) {
        final dynamic rawData = result.data;

        if (rawData is! List) {
          throw FormatException(
            'Os dados retornados da API não são uma lista válida.',
          );
        }

        final list = rawData
            .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }

      return Left(ServerErrorHandler.handle(result));
    } catch (e, stackTrace) {
      _logger.logPrint('Erro ao processar Exercise: $e');
      _logger.logPrint('Stacktrace: $stackTrace');

      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('timeout') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('socket')) {
        return Left(
          NetworkFailure(
            'Sem conexão com a internet. Verifique sua rede e tente novamente.',
          ),
        );
      }

      return Left(
        InternalFailure(
          'Ocorreu um erro interno ao processar os dados dos exercícios',
        ),
      );
    }
  }
}
