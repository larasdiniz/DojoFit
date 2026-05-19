import 'package:flutter/material.dart';
import '../core/injectors/exercises_injector.dart';
import '../features/exercises/presentation/pages/exercises_page.dart';

void mainMock() {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = exercisesInjectorModule(isMock: true);
  // injector.commit();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExercisesPage(ambiente: 'MOCK (Dados Locais)'),
    ),
  );
}
