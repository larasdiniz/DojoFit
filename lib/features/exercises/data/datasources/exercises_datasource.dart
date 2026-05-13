import 'package:pop_network/pop_network.dart';

class ExercisesDatasource {
  final IApiManager _apiManager;

  ExercisesDatasource(this._apiManager); // isso é injecao de dependencia

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
      mockPath: 'assets/api/mock/exercises_list_mock',
      status: HttpStatusEnum.ok,
    ),
  );
}
