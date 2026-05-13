import 'package:dojofit/features/exercises/data/models/exercise_model.dart';
import 'package:dojofit/features/exercises/domain/entities/exercise_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseModel', () {
    test('Derve ser uma subclasse de ExerciseEntity', () {
      // arrange
      final json = {
        "name": "Incline Hammer Curls",
        "type": "strength",
        "muscle": "biceps",
        "difficulty": "beginner",
        "equipments": ["dumbbells"],
      };

      // act
      final model = ExerciseModel.fromJson(json);

      // assert
      expect(model, isA<ExerciseEntity>());
    });

    test('Deve mapear corretaemnte a lista de equipments', () {
      // arrange
      final json = {
        "name": "Incline Hammer Curls",
        "equipments": ["dumbbells", "incline bench"],
        "safety_info": "Keep your back firm.",
      };

      // act
      final model = ExerciseModel.fromJson(json);

      // assert
      expect(model.equipments, isA<List<String>>());
      expect(model.equipments.length, 2);
      expect(model.equipments, contains('dumbbells'));
      expect(model.equipments, contains('incline bench'));
    });

    test(
      'Deve retornar uma lista vazia quando equipments vier nulo no JSON',
      () {
        // arrange
        final json = {'name': 'Push up', 'equipments': null};

        // act
        final model = ExerciseModel.fromJson(json);

        // assert
        expect(model.equipments, isA<List<String>>());
        expect(model.equipments, isEmpty);
      },
    );

    test(
      'Deve garantir que valores obrigatórios nulos retornem strings vazias (Null Safety)',
      () {
        // arrange
        final json = {'name': null, 'type': null, 'muscle': null};
        // act
        final model = ExerciseModel.fromJson(json);
        // assert
        expect(model.name, '');
        expect(model.type, '');
        expect(model.muscle, '');
      },
    );
  });
}
