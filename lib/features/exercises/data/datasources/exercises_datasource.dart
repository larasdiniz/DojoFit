import 'package:pop_network/pop_network.dart';

class ExercisesDatasource {
  final IApiManager _apiManager;

  ExercisesDatasource(this._apiManager); // Isso é inversão de dependência

  Future<Response<dynamic>> getExercises({
    String? name,
    String? type,
    String? muscle,
    String? difficulty,
    List<String>? equipments,
  }) => _apiManager.get(
    '/v1/exercises',
    queryParameters: {
      'name': name,
      'type': type,
      'muscle': muscle,
      'difficulty': difficulty,
      if (equipments?.isNotEmpty ?? false) 'equipment': equipments!.first,
    },
    mockReplyParams: MockReplyParams(
      mockPath: _getMock(
        name: name,
        muscle: muscle,
        type: type,
        difficulty: difficulty,
      ),
      status: HttpStatusEnum.ok,
    ),
  );

  String _getMock({
    String? name,
    String? muscle,
    String? type,
    String? difficulty,
  }) {
    if (name == 'erro') {
      return 'assets/api/mock/get_exercises_error.json';
    }
    if (name == 'vazio' || muscle == 'vazio') {
      return 'assets/api/mock/get_exercises_empty.json';
    }
    if (muscle == 'chest') {
      return 'assets/api/mock/exercises_search_chest_mock.json';
    }
    return 'assets/api/mock/exercises_list_mock.json';
  }
}
