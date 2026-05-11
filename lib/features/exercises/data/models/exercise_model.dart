import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';

extension type ExerciseModel(ExerciseEntity entity) implements ExerciseEntity {
  ExerciseModel.fromJson(Map<String, dynamic> json)
    : entity = ExerciseEntity(
        name: json['name'] ?? '',
        type: json['ype'] ?? '',
        muscle: json['muscle'] ?? '',
        difficulty: json['difficulty'] ?? '',
        equipments: (json['equipments'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        instructions: json['instructions'] ?? '',
        safetyInfo: json['safety_info'] ?? '',
      );

  Map<String, dynamic> get toJson => <String, dynamic>{
    'name': entity.name,
    'type': entity.type,
    'muscle': entity.muscle,
    'difficulty': entity.difficulty,
    'equipments': entity.equipments,
    'instructions': entity.instructions,
    'safety_info': entity.safetyInfo,
  };
}
