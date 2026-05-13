import 'package:flutter/material.dart';
import 'package:dojofit/core/injectors/exercises_injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = exercisesInjectorModule(isMock: false);

  injector.commit();

  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('DojoFit - Ambiente PROD'))),
    ),
  );
}
