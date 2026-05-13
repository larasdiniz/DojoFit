import 'package:auto_injector/auto_injector.dart';
import 'package:dojofit/core/network/network_config.dart';
import 'package:dojofit/features/exercises/data/datasources/exercises_datasource.dart';
import 'package:dojofit/features/exercises/data/repositories/exercises_repository_impl.dart';
import 'package:dojofit/features/exercises/domain/repositories/i_exercises_repository.dart';
import 'package:dojofit/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:pop_network/pop_network.dart';

AutoInjector exercisesInjectorModule({bool isMock = false}) => AutoInjector(
  tag: 'exercisesInjectorModule',
  on: (i) {
    // 1. Camada de Network (External)
    i.addSingleton<IApiManager>(
      () => NetworkConfig.create(
        baseUrl: 'https://api.api-ninjas.com',
        isMock: isMock,
      ),
    );

    i.addSingleton<ExercisesDatasource>(ExercisesDatasource.new);

    i.addSingleton<IExercisesRepository>(
      ExercisesRepositoryImpl.new,
    ); // isso é inversao de dependencia

    i.addSingleton<GetExercisesUseCase>(GetExercisesUseCase.new);

    i.commit();
  },
);
