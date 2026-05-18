import 'package:flutter/material.dart';
import '../core/injectors/exercises_injector.dart';

void mainMock() {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = exercisesInjectorModule(isMock: true);

  injector.commit();

  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('DojoFit - Ambiente MOCK'))),
    ),
  );
}
