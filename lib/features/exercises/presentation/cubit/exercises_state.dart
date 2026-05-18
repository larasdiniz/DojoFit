import '../../domain/entities/exercise_entity.dart';

sealed class ExercisesState {}

class ExercisesInitial extends ExercisesState {}

class ExercisesLoading extends ExercisesState {}

class ExercisesSuccess extends ExercisesState {
  final List<ExerciseEntity> exercises;
  ExercisesSuccess(this.exercises);
}

class ExercisesError extends ExercisesState {
  final String message;
  ExercisesError(this.message);
}
