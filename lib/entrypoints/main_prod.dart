import 'package:flutter/material.dart';
import '../core/injectors/exercises_injector.dart';

void mainProd() {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = exercisesInjectorModule(isMock: false);

  injector.commit();

  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('DojoFit - Ambiente PROD'))),
    ),
  );
}
