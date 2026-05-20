import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injectors/exercises_injector.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/get_exercises_usecase.dart';
import '../cubit/exercises_cubit.dart';
import '../cubit/exercises_state.dart';
import '../widgets/card_exercicio.dart';
import '../widgets/componente_erro.dart';
import '../widgets/filter_chip_list.dart';

class ExercisesPage extends StatefulWidget {
  final String ambiente;

  const ExercisesPage({super.key, required this.ambiente});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  late final ExercisesCubit _cubit;

  String _ultimoMuscle = 'chest';
  String? _ultimoName;

  @override
  void initState() {
    super.initState();

    final isMockEnv = widget.ambiente.contains('MOCK');

    final moduloInjecao = exercisesInjectorModule(isMock: isMockEnv);

    final useCase = moduloInjecao.get<GetExercisesUseCase>();

    _cubit = ExercisesCubit(getExercisesUseCase: useCase);

    _cubit.loadExercises(muscle: _ultimoMuscle);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMock = widget.ambiente.contains('MOCK');
    final statusColor = isMock ? Colors.amber : Colors.green;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.tituloApp.texto),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(isMock ? 64 : 24),
            child: Column(
              children: [
                Container(
                  color: statusColor,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  child: Text(
                    'Ambiente Ativo: ${widget.ambiente}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (isMock)
                  FilterChipList(
                    onFilterChanged: (tipo, {muscle, name}) {
                      _ultimoMuscle = muscle ?? '';
                      _ultimoName = name;

                      _cubit.loadExercises(muscle: muscle, name: name);
                    },
                  ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ExercisesCubit, ExercisesState>(
          builder: (context, state) {
            if (state is ExercisesLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(AppStrings.loading.texto),
                  ],
                ),
              );
            }

            if (state is ExercisesError) {
              return ComponenteErro(
                mensagem: state.message,
                onRetry: () => _cubit.loadExercises(
                  muscle: _ultimoMuscle,
                  name: _ultimoName,
                ),
              );
            }

            if (state is ExercisesSuccess) {
              if (state.exercises.isEmpty) {
                return Center(child: Text(AppStrings.nenhumExercicio.texto));
              }

              return ListView.builder(
                itemCount: state.exercises.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final exercise = state.exercises[index];

                  return CardExercicio(
                    nome: exercise.name,
                    categoria: exercise.type,
                    subtitulo: AppStrings.infoExercicio(
                      muscle: exercise.muscle,
                      difficulty: exercise.difficulty,
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
