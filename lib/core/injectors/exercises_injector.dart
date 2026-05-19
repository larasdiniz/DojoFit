import 'package:auto_injector/auto_injector.dart';
import 'package:dojofit/core/network/network_logger.dart';
import 'package:pop_network/pop_network.dart';

import '../../features/exercises/data/datasources/exercises_datasource.dart';
import '../../features/exercises/data/repositories/exercises_repository_impl.dart';
import '../../features/exercises/domain/repositories/i_exercises_repository.dart';
import '../../features/exercises/domain/usecases/get_exercises_usecase.dart';
import '../network/network_config.dart';

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

    i.addSingleton<NetworkLogger>(NetworkLogger.new);

    i.addSingleton<ExercisesDatasource>(ExercisesDatasource.new);

    i.addSingleton<IExercisesRepository>(
      () => ExercisesRepositoryImpl(datasource: i.get(), logger: i.get()),
    ); // isso é injecao de dependencia

    i.addSingleton<GetExercisesUseCase>(GetExercisesUseCase.new);

    i.commit();
  },
);
