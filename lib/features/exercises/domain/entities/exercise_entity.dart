import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String name;
  final String type;
  final String muscle;
  final String difficulty;
  final List<String> equipments;
  final String? instructions;
  final String? safetyInfo;

  const ExerciseEntity({
    required this.name,
    required this.type,
    required this.muscle,
    required this.difficulty,
    required this.equipments,
    this.instructions,
    this.safetyInfo,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    muscle,
    difficulty,
    equipments,
    instructions,
    safetyInfo,
  ];
}
