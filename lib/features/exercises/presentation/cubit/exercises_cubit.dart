import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_exercises_usecase.dart';
import 'exercises_state.dart';

class ExercisesCubit extends Cubit<ExercisesState> {
  final GetExercisesUseCase _getExercisesUseCase;

  ExercisesCubit({required GetExercisesUseCase getExercisesUseCase})
    : _getExercisesUseCase = getExercisesUseCase,
      super(ExercisesInitial());

  Future<void> loadExercises({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  }) async {
    emit(ExercisesLoading());

    final result = await _getExercisesUseCase(
      name: name,
      type: type,
      muscle: muscle,
      difficulty: difficulty,
      equipments: equipments,
    );

    result.fold(
      (failure) => emit(ExercisesError(failure.message)),
      (exercisesList) => emit(ExercisesSuccess(exercisesList)),
    );
  }
}
