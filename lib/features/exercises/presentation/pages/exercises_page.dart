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

  // Guardamos os últimos parâmetros para o botão "Tentar Novamente" saber o que buscar
  String _ultimoMuscle = 'chest';
  String? _ultimoName;

  @override
  void initState() {
    super.initState();

    // 1. 🟢 Descobrimos se a tela foi aberta pelo ambiente de MOCK olhando a String que veio do main
    final isMockEnv = widget.ambiente.contains('MOCK');

    // 2. 🟢 Passamos esse booleano para o injetor corporativo.
    // Assim, se for o mainMock, o isMock vira TRUE e liga o mock do PopNetwork!
    final moduloInjecao = exercisesInjectorModule(isMock: isMockEnv);

    // 3. 🟢 Buscamos o Caso de Uso do módulo já configurado com o ambiente certo
    final useCase = moduloInjecao.get<GetExercisesUseCase>();

    // 4. Instanciamos o Cubit injetando o Caso de Uso
    _cubit = ExercisesCubit(getExercisesUseCase: useCase);

    // 5. Disparamos a busca inicial padrão
    _cubit.loadExercises(muscle: _ultimoMuscle);
  }

  @override
  void dispose() {
    // Sempre fechar o Cubit para evitar vazamento de memória (Memory Leak)
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
            // Se for MOCK, aumentamos a barra para caber os botões de teste dos JSONs
            preferredSize: Size.fromHeight(isMock ? 64 : 24),
            child: Column(
              children: [
                // Faixa colorida indicando o ambiente ativo (Amber para Mock, Verde para Prod)
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
                // Se o ambiente for MOCK, injetamos a lista de botões para testar os arquivos locais
                if (isMock)
                  FilterChipList(
                    onFilterChanged: (tipo, {muscle, name}) {
                      _ultimoMuscle = muscle ?? '';
                      _ultimoName = name;

                      // O chip avisa que mudou e o Cubit dispara a busca do JSON correspondente
                      _cubit.loadExercises(muscle: muscle, name: name);
                    },
                  ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ExercisesCubit, ExercisesState>(
          builder: (context, state) {
            // CASO 1: Estado de Carregamento (Loading)
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

            // CASO 2: Estado de Erro (Bateu no JSON get_exercises_error)
            if (state is ExercisesError) {
              return ComponenteErro(
                mensagem: state.message,
                onRetry: () => _cubit.loadExercises(
                  muscle: _ultimoMuscle,
                  name: _ultimoName,
                ),
              );
            }

            // CASO 3: Estado de Sucesso (Leu a lista do JSON ou da API real)
            if (state is ExercisesSuccess) {
              // Se o JSON retornou uma lista vazia [] (Caso do get_exercises_empty)
              if (state.exercises.isEmpty) {
                return Center(child: Text(AppStrings.nenhumExercicio.texto));
              }

              // Se a lista veio cheia, renderiza o ListView na tela
              return ListView.builder(
                itemCount: state.exercises.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final exercise = state.exercises[index];

                  // Consome o widget de Card isolado passando as informações mapeadas do JSON
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
