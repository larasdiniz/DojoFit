import 'package:flutter/material.dart';
import '../core/injectors/exercises_injector.dart';
import '../features/exercises/presentation/pages/exercises_page.dart';

void mainProd() {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = exercisesInjectorModule(isMock: false);
  // injector.commit();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExercisesPage(ambiente: 'PROD (API Real)'),
    ),
  );
}
